Return-Path: <linux-kernel-owner+w=401wt.eu-S1758093AbYDJXZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093AbYDJXZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 19:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbYDJXZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 19:25:16 -0400
Received: from styx.suse.cz ([82.119.242.94]:41346 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751036AbYDJXZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 19:25:15 -0400
Date: Fri, 11 Apr 2008 01:25:13 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Pavel Machek <pavel@ucw.cz>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Andi Kleen <andi@firstfloor.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: BUG: using smp_processor_id() during suspend with 2.6.25-rc8
In-Reply-To: <20080410094554.GA10321@ucw.cz>
Message-ID: <Pine.LNX.4.64.0804110122470.3896@jikos.suse.cz>
References: <c4e36d110804070625n17eb44e1nbb5558f500f13438@mail.gmail.com>
 <Pine.LNX.4.64.0804080008420.3896@jikos.suse.cz> <20080407222352.GG16647@one.firstfloor.org>
 <200804080029.31102.rjw@sisk.pl> <Pine.LNX.4.64.0804080030500.3896@jikos.suse.cz>
 <20080410094554.GA10321@ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2008, Pavel Machek wrote:

> > > > sysdevs were always supposed to run completely with interrupts off. If they 
> > > > don't anymore that's some kind of higher level resume code bug which you need 
> > > > to fix there, not hack around in the low level code.
> > > They are executed with interrupts disabled, on one CPU.
> > So, any idea why mce_resume() -> mce_init() -> debug_smp_processor_id() 
> > triggers the warning? Apparently preempt_count is zero, irqs_disabled() 
> > returns false, and cpumask_of_cpu() is not equal to current->cpus_allowed.
> We are single-threaded because we 'unplugged' all the other cpus... but 
> I'm not sure the BUG() code realises that...

That's unrelated, right? The real problem here is that irqs_disabled() 
call inside debug_smp_processor_id() signalized that interrupts are 
enabled, and that (correctly) triggered the bug.

-- 
Jiri Kosina
SUSE Labs
