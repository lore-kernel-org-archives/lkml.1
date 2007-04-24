Return-Path: <linux-kernel-owner+w=401wt.eu-S1423000AbXDXSeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423000AbXDXSeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 14:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423005AbXDXSeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 14:34:15 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423000AbXDXSeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 14:34:14 -0400
Date: Tue, 24 Apr 2007 11:32:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>,
       virtualization@lists.osdl.org, Prarit Bhargava <prarit@redhat.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Zachary Amsden <zach@vmware.com>, James Morris <jmorris@namei.org>,
       Dan Hecht <dhecht@vmware.com>, Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Chris Lalancette <clalance@redhat.com>,
       Rick Lindsley <ricklind@us.ibm.com>, Andi Kleen <ak@suse.de>
Subject: Re: [patch 1/4] Ignore stolen time in the softlockup watchdog
Message-Id: <20070424113222.ed2e1314.akpm@linux-foundation.org>
In-Reply-To: <462E4969.6070802@goop.org>
References: <20070327214919.800272641@goop.org>
	<20070327215827.871954359@goop.org>
	<20070423234910.50149faf.akpm@linux-foundation.org>
	<462E43A7.1050001@goop.org>
	<20070424105738.e0ce36a9.akpm@linux-foundation.org>
	<462E4969.6070802@goop.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007 11:16:09 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Andrew Morton wrote:
> > I said that because the damn thing went away when I was hunting it down
> > because I lost the config and was unable to remember the right combination
> > of debug settings.  Fortunately it later came back so I took care to
> > preserve the config.
> >   
> 
> sched_clock doesn't *do* anything except flap interrupts.

Well, it _is_ mysterious.

Did you try to locate the code which failed?  I got lost in macros and
include files, and gave up very very easily.  Stop hiding, Ingo.

> Oh, wait, have
> you got Andi's bugfixed version of the sched_clock patch?  The first
> version did a local_save_flags rather than a local_irq_save.

I have whatever I pulled from firstfloor over the weekend.  It's in
rc7-mm1.  No, it doesn't use local_save_flags.

> >> Hm, is it caused by using sched_clock() to generate the printk
> >> timestamps while generating the lock test output?
> >>     
> >
> > Conceivably.  What does that locking API test do?
> >   
> 
> Didn't make a difference here.  Building your config now.
> 
> > I was using printk timestamps and netconsole at the time.
> >   
> 
> Ah, great, now you're going to make me setup netconsole...
> 

That's a doddle.

On test system, boot with

netconsole=4444@<test-system-ip-addr>/eth0,<udp-port-no>@<workstation-ip-addr>/<workstation-mac-addr>

On workstation:

sudo netcat -u -l -p <udp-port-no> | tee -a ~/.log/log-<test-system-hostname>
