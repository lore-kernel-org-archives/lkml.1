Return-Path: <linux-kernel-owner+w=401wt.eu-S1758666AbYHVJSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666AbYHVJSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 05:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbYHVJS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 05:18:29 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44415 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbYHVJS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 05:18:28 -0400
Date: Fri, 22 Aug 2008 11:18:27 +0200
From: Pavel Machek <pavel@suse.cz>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Max Krasnyanskiy <maxk@qualcomm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: latest -git: hibernate: possible circular locking dependency detected
Message-ID: <20080822091827.GC6542@atrey.karlin.mff.cuni.cz>
References: <19f34abd0808210804y7ee91d1fy12da5ad6f82d2451@mail.gmail.com> <b647ffbd0808211038h686f9df3ud335efbc46242952@mail.gmail.com> <19f34abd0808211059m451f5f7au949217aeecccccaf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0808211059m451f5f7au949217aeecccccaf@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > this path is triggered as a result of "echo disk > /sys/power/state"
> 
> Yes. That is what I typed.
> 
> >
> > disable_nonboot_cpus() calls cpu_maps_update_being() which takes
> > "cpu_add_remove_lock" (lock-1).
> >
> > If we go down the road cleanup_workqueue_thread() ->
> > flush_cpu_workqueue() will take "cwq->lock" (lock-2).
> > So this should be the second lock.
> >
> >
> [...]
> 
> > hmm, did you somehow hit "Sysrq + o"?
> >
> > 'cause I don't see any other places (say, with handle_sysrq(k,...)
> > where "k" migth be 'o') from where do_power_off() might have been
> > triggered...
> >
> 
> No. But in my logs I often saw SysRq triggered, even though I didn't
> do it any of these times:
> 
> log-20080821-104053.txt:SysRq : SysRq : Show State
> log-20080821-105541.txt:SysRq : Emergency Sync
> log-20080821-105541.txt:SysRq : Emergency Sync
> log-20080821-105541.txt:SysRq : Power Off
> log-20080821-110514.txt:SysRq : Terminate All Tasks
> log-20080821-111650.txt:SysRq : HELP : loglevel0-8 <6>serial 00:0d: activated
> log-20080821-111650.txt:SysRq : Power Off
> log-20080821-111650.txt:SysRq : Terminate All Tasks
> log-20080821-111650.txt:SysRq : SysRq : <6>serial 00:0d: activated
> log-20080821-120628.txt:SysRq : SysRq : HELP : HELP : <6>serial 00:0d: activated
> log-20080821-120628.txt:SysRq : SysRq : HELP : HELP : <6>serial 00:0d: activated
> 
> (And it seems to pick a random letter too. It even showed the "HELP:"
> line at one point!)
> 
> I have no idea why this happens. Is it possible to trigger SysRq by
> writing data on the other end of the serial console? (Maybe my cable
> is bad or something, but data seems to be going in both directions
> over my serial console.)

Serial break translates to sysrq, IIRC.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
