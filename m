Return-Path: <linux-kernel-owner+w=401wt.eu-S1757353AbZBWRCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353AbZBWRCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 12:02:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755880AbZBWRC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 12:02:26 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49169 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755800AbZBWRCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 12:02:25 -0500
Date: Mon, 23 Feb 2009 17:59:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] move exit_ptrace() from forget_original_parent()
	to do_exit()
Message-ID: <20090223165932.GB16294@redhat.com>
References: <20090211211221.GA16857@redhat.com> <20090220022832.CA587FC2F7@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220022832.CA587FC2F7@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19, Roland McGrath wrote:
>
> > If we ever change exit_ptrace() to do the blocking calls, it makes
> > sense to move it after exit_signals().
>
> I'm not sure I understand this comment.  I guess you just mean that if we
> block, we should be sure to do the exit_signals() pass-the-pending-buck
> work afterwards.

Another reason: it is better to set PF_EXITING asap, before doing something
which can block/etc. PF_EXITING means that complete_signal()->wants_signal()
will not pick us as ->curr_target.

> OK.  But I think we want it after exit_signals anyway so
> that ptrace_traceme() can check PF_EXITING (cf 1/4 review).

Yes, you are right.

> Also, I think this patch should be the very last of the series.

Agreed.

Oleg.

