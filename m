Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbXIYMiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbXIYMiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 08:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbXIYMiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 08:38:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34312 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbXIYMiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 08:38:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.23-rc4-mm1 and -rc6-mm1: boot failure on HP nx6325, related to clockevents
Date: Tue, 25 Sep 2007 14:52:00 +0200
User-Agent: KMail/1.9.5
Cc: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
       Chuck Ebbert <cebbert@redhat.com>
References: <20070925101418.68d30a72@localhost> <200709251420.44345.rjw@sisk.pl> <1190723305.4035.327.camel@chaos>
In-Reply-To: <1190723305.4035.327.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709251452.01415.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 25 September 2007 14:28, Thomas Gleixner wrote:
> On Tue, 2007-09-25 at 14:20 +0200, Rafael J. Wysocki wrote:
> > > > > As i can see from the log, you are booting on computer with dualcore AMD
> > > > > processor. Do you have C1E feature enabled? 
> > 
> > That's possible, how to check?
> > 
> > > > > i386 kernel disable lapic on dualcore AMD with C1E support (see 
> > > > > http://lkml.org/lkml/2007/3/29/199). x86_64 kernel do not have this
> > > > > patch still (it's required for tickless kernel only).
> > > > 
> > > > Well it is required for non tickless mode as well.
> > > > 
> > > > >  As result, if
> > > > > you run x86_64 kernel with hrt patch on such computer, the system
> > > > > will stall during boot on lapic timer calibration.
> > > > 
> > > > Thanks for the reminder. I have a look into this.
> > > 
> > > Can you please boot mainline and provide the output of:
> > > 
> > > # cat /proc/interrupts; sleep 10; cat /proc/interrupts
> > 
> > albercik:~ # cat /proc/interrupts; sleep 10; cat /proc/interrupts
> >            CPU0       CPU1
> >   0:    1159492          0  local-APIC-edge      timer
> > LOC:          0    1158220   Local interrupts
> >
> >   0:    1161996          0  local-APIC-edge      timer
> > LOC:          0    1160723   Local interrupts
> 
> Hmm. That's strange. It looks like the local apic timer is not used, but
> x86_64 definitely lacks the above check.

Ouch, sorry.  This is from the kernel booted with "noapictimer".

I'll get the correct output in a little while.

Greetings,
Rafael
