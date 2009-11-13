Return-Path: <linux-kernel-owner+w=401wt.eu-S932466AbZKMXQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466AbZKMXQZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 18:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932436AbZKMXQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 18:16:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932371AbZKMXQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 18:16:19 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH -tip 1/3] Pass mm->flags to binfmt core_dump for bitflag
	consistency
In-Reply-To: Masami Hiramatsu's message of  Friday, 13 November 2009 17:52:27 -0500 <20091113225226.15079.90813.stgit@harusame>
References: <20091113225226.15079.90813.stgit@harusame>
X-Zippy-Says: Will the third world war keep ``Bosom Buddies'' off the air?
Message-Id: <20091113231602.2DD2C100E@magilla.sf.frob.com>
Date: Fri, 13 Nov 2009 15:16:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To clarify, proc_coredump_filter_write() is the one place that can change
mm->flags during a core dump.  I don't think any other is possible while
all the other tasks sharing that mm are prevented from running.  Is there
any other way that mm->flags might change during do_coredump()?

I don't see anything wrong with this change.  But (assuming that is the
only case), there is another approach we could take instead.  That is,
have proc_coredump_filter_write() do:

	down_read(&mm->mmap_sem);
	ret = mm->core_state ? -EBUSY : 0;
	up_read(&mm->mmap_sem);


Thanks,
Roland
