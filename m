Return-Path: <linux-kernel-owner+w=401wt.eu-S1161746AbXDXNLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161746AbXDXNLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 09:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161753AbXDXNLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 09:11:32 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:53282 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161746AbXDXNLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 09:11:32 -0400
Date: Tue, 24 Apr 2007 15:07:20 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>
Cc: Thiemo.Nagel@ph.tum.de, linuxkernel Org <linux-kernel@vger.kernel.org>
Subject: Re: [OOPS] 2.6.21-rc6-git5 in cfq_dispatch_insert
Message-ID: <20070424130720.GM3744@kernel.dk>
References: <79880979-51BB-4D28-A3E8-3AE0F56F5B0A@e18.physik.tu-muenchen.de> <20070424091807.GA3744@kernel.dk> <6A6800B3-F9C8-4046-9E1C-A8CEA81B2CE0@e18.physik.tu-muenchen.de> <20070424093904.GB3744@kernel.dk> <20070424094003.GC3744@kernel.dk> <5A404D4C-BB61-45AB-9A7A-B380FE222137@e18.physik.tu-muenchen.de> <20070424123200.GK3744@kernel.dk> <ACEFEB0C-704B-49C8-96A7-14C0C54EF067@e18.physik.tu-muenchen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ACEFEB0C-704B-49C8-96A7-14C0C54EF067@e18.physik.tu-muenchen.de>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24 2007, Roland Kuhn wrote:
> Hi Jens!
> 
> On 24 Apr 2007, at 14:32, Jens Axboe wrote:
> 
> >On Tue, Apr 24 2007, Roland Kuhn wrote:
> >>Hi Jens!
> >>
> >>[I made a typo in the Cc: list so that lkml is only included as of
> >>now. Actually I copied the typo from you ;-) ]
> >
> >Well no, you started the typo, I merely propagated it and forgot to  
> >fix
> >it up :-)
> >
> Actually, I copied it from your printk() ;-) (thinking helps...)

Ahhh! Yeah that one indeed has a typo, tsk tsk.

> >>>>>Sure. You might want to include NFS file access into your tests,
> >>>>>since we've not triggered this with locally accessing the disks.
> >>>>>BTW:
> >>>>
> >>>>How are you exporting the directory (what exports options) - how
> >>>>is it
> >>>>mounted by the client(s)? What chunksize is your raid6 using?
> >>>
> >>>And what are the nature of the files on the raid (huge, small, ?)  
> >>>and
> >>>what are the client(s) doing? Just approximately, I know these  
> >>>things
> >>>can be hard/difficult/impossible to specify.
> >>>
> >>The files are 100-400MB in size and the client is merging them into a
> >>new file in the same directory using the ROOT library, which does in
> >>essence alternating sequences of
> >>
> >>_llseek(somewhere)
> >>read(n bytes)
> >>_llseek(somewhere+n)
> >>read(m bytes)
> >>...
> >>
> >>and then
> >>
> >>_llseek(somewhere)
> >>rt_sigaction(ignore INT)
> >>write(n bytes)
> >>rt_sigaction(INT->DFL)
> >>time()
> >>_llseek(somewhere+n)
> >>...
> >>
> >>where n is of the the order of 30kB. The input files are treated
> >>sequentially, not randomly.
> >
> >Ok, I'll see if I can reproduce it. No luck so far, I'm afraid.
> >
> Too bad.
> 
> >>BTW: the machine just stopped dead, no sign whatsoever on console or
> >>netconsole, so I rebooted with elevator=deadline
> >>(need to get some work done besides ;-) )
> >
> >Unfortunately expected, if we can race and lose an update to - 
> >>next_rq,
> >we can race and corrupt some of the internal data structures as  
> >well. If
> >you have the time and inclination, it would be interesting to see  
> >if you
> >can reproduce with some debugging options enabled:
> >
> >- Enable all preempt, spinlock and lockdep debugging measures
> >- Possibly slab poisoning, although that may slow you down somewhat
> >
> Kernel compilation under way, will report back.

Thanks!

> >Are you using 4kb stacks?
> >
> No idea, 'grep -i stack .config' gives no indication, but ISTR that  
> 4k was made the default some time back?

You are on x86-64, my mistake.

-- 
Jens Axboe

