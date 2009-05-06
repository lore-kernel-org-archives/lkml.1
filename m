Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbZEFIko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbZEFIko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 04:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbZEFIkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 04:40:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45822 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059AbZEFIke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 04:40:34 -0400
Date: Wed, 6 May 2009 10:40:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Tom Zanussi <tzanussi@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 4/4] tracing/events: fix concurrent access to
	ftrace_events list
Message-ID: <20090506084014.GD28675@elte.hu>
References: <4A00F6AD.2070008@cn.fujitsu.com> <4A00F709.3080800@cn.fujitsu.com> <20090506052730.GA5986@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506052730.GA5986@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Wed, May 06, 2009 at 10:33:45AM +0800, Li Zefan wrote:
> > A module will add/remove its trace events when it gets loaded/unloaded, so
> > the ftrace_events list is not "const", and concurrent access needs to be
> > protected.
> > 
> > This patch thus fixes races between loading/unloding modules and read
> > 'available_events' or read/write 'set_event', etc.
> > 
> > Below shows how to reproduce the race:
> > 
> >  # for ((; ;)) { cat /mnt/tracing/available_events; } > /dev/null &
> >  # for ((; ;)) { insmod trace-events-sample.ko; rmmod sample; } &
> > 
> > After a while:
> > 
> > BUG: unable to handle kernel paging request at 0010011c
> > IP: [<c1080f27>] t_next+0x1b/0x2d
> > ...
> > Call Trace:
> >  [<c10c90e6>] ? seq_read+0x217/0x30d
> >  [<c10c8ecf>] ? seq_read+0x0/0x30d
> >  [<c10b4c19>] ? vfs_read+0x8f/0x136
> >  [<c10b4fc3>] ? sys_read+0x40/0x65
> >  [<c1002a68>] ? sysenter_do_call+0x12/0x36
> > 
> > [ Impact: fix races when concurrent accessing ftrace_events list ]
> > 
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> 
> Nice series of fixes!
> 
> Thanks!

I've applied them to tip/tracing/events, thanks guys!

	Ingo
