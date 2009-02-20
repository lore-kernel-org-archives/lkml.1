Return-Path: <linux-kernel-owner+w=401wt.eu-S1753232AbZBTC3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbZBTC3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 21:29:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755355AbZBTC2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 21:28:49 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755313AbZBTC2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 21:28:47 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] move exit_ptrace() from forget_original_parent() to
	do_exit()
In-Reply-To: Oleg Nesterov's message of  Wednesday, 11 February 2009 22:12:21 +0100 <20090211211221.GA16857@redhat.com>
References: <20090211211221.GA16857@redhat.com>
X-Windows: dissatisfaction guaranteed.
Message-Id: <20090220022832.CA587FC2F7@magilla.sf.frob.com>
Date: Thu, 19 Feb 2009 18:28:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If we ever change exit_ptrace() to do the blocking calls, it makes
> sense to move it after exit_signals().

I'm not sure I understand this comment.  I guess you just mean that if we
block, we should be sure to do the exit_signals() pass-the-pending-buck
work afterwards.  OK.  But I think we want it after exit_signals anyway so
that ptrace_traceme() can check PF_EXITING (cf 1/4 review).

Also, I think this patch should be the very last of the series.  The others
reorganize code but we don't think they really reorder anything.  This one
we thinks reorders things in a way that's fine, but it clearly does a big
shift of the ordering of where ptrace cleanups happen relative to lots of
other tear-down.  So that seems the most likely to cause some unimagined
subtle regression down the line.  If it comes to a bisect that hits this
patch, I think we'd rather be comparing one with all those tweaks to
forget_original_parent merged in as the baseline than juggling their
incremental effects after this one's big reordering.


Thanks,
Roland
