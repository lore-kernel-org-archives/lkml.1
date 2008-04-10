Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbYDJJrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbYDJJrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 05:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbYDJJrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 05:47:36 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2417 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752265AbYDJJrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 05:47:35 -0400
Date: Thu, 10 Apr 2008 11:45:54 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Andi Kleen <andi@firstfloor.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: BUG: using smp_processor_id() during suspend with 2.6.25-rc8
Message-ID: <20080410094554.GA10321@ucw.cz>
References: <c4e36d110804070625n17eb44e1nbb5558f500f13438@mail.gmail.com> <Pine.LNX.4.64.0804080008420.3896@jikos.suse.cz> <20080407222352.GG16647@one.firstfloor.org> <200804080029.31102.rjw@sisk.pl> <Pine.LNX.4.64.0804080030500.3896@jikos.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804080030500.3896@jikos.suse.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-04-08 00:33:48, Jiri Kosina wrote:
> On Tue, 8 Apr 2008, Rafael J. Wysocki wrote:
> 
> > > The mce resume is a sysdev.
> > > sysdevs were always supposed to run completely with interrupts off. If they 
> > > don't anymore that's some kind of higher level resume code bug which you need 
> > > to fix there, not hack around in the low level code.
> > They are executed with interrupts disabled, on one CPU.
> 
> So, any idea why mce_resume() -> mce_init() -> debug_smp_processor_id() 
> triggers the warning? Apparently preempt_count is zero, irqs_disabled() 
> returns false, and cpumask_of_cpu() is not equal to current->cpus_allowed.

We are single-threaded because we 'unplugged' all the other cpus...
but I'm not sure the BUG() code realises that...

> So there clearly is a bug somewhere.
> 
> > > Obviously turning on preemption anywhere around the machine check is
> > > fatal because it touches CPU state and if you reschedule you could
> > > switch to another CPU and change or access the wrong CPU's state.
> > FWIW, at the point when sysdevs are resumed we are single-threaded.
> 
> Is that really relevant here? We still could be switched over to another 
> CPU, and that would break things.

There are no other CPUs.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
