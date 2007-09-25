Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbXIYM2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbXIYM2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 08:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbXIYM2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 08:28:31 -0400
Received: from www.osadl.org ([213.239.205.134]:50297 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751164AbXIYM2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 08:28:30 -0400
Subject: Re: 2.6.23-rc4-mm1 and -rc6-mm1: boot failure on HP nx6325,
	related to clockevents
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
       Chuck Ebbert <cebbert@redhat.com>
In-Reply-To: <200709251420.44345.rjw@sisk.pl>
References: <20070925101418.68d30a72@localhost>
	 <1190707673.4035.275.camel@chaos> <1190712618.4035.286.camel@chaos>
	 <200709251420.44345.rjw@sisk.pl>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 14:28:25 +0200
Message-Id: <1190723305.4035.327.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-25 at 14:20 +0200, Rafael J. Wysocki wrote:
> > > > As i can see from the log, you are booting on computer with dualcore AMD
> > > > processor. Do you have C1E feature enabled? 
> 
> That's possible, how to check?
> 
> > > > i386 kernel disable lapic on dualcore AMD with C1E support (see 
> > > > http://lkml.org/lkml/2007/3/29/199). x86_64 kernel do not have this
> > > > patch still (it's required for tickless kernel only).
> > > 
> > > Well it is required for non tickless mode as well.
> > > 
> > > >  As result, if
> > > > you run x86_64 kernel with hrt patch on such computer, the system
> > > > will stall during boot on lapic timer calibration.
> > > 
> > > Thanks for the reminder. I have a look into this.
> > 
> > Can you please boot mainline and provide the output of:
> > 
> > # cat /proc/interrupts; sleep 10; cat /proc/interrupts
> 
> albercik:~ # cat /proc/interrupts; sleep 10; cat /proc/interrupts
>            CPU0       CPU1
>   0:    1159492          0  local-APIC-edge      timer
> LOC:          0    1158220   Local interrupts
>
>   0:    1161996          0  local-APIC-edge      timer
> LOC:          0    1160723   Local interrupts

Hmm. That's strange. It looks like the local apic timer is not used, but
x86_64 definitely lacks the above check. Can you please remove/disable
the acpi processor module and recheck ?

	tglx




