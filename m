Return-Path: <linux-kernel-owner+w=401wt.eu-S1030447AbXAaRkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030447AbXAaRkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 12:40:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030456AbXAaRkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 12:40:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58738 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030447AbXAaRkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 12:40:15 -0500
Date: Wed, 31 Jan 2007 18:38:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.20-rc6 - sky2 resume breakage
Message-ID: <20070131173832.GA13653@elte.hu>
References: <20070129154518.40b0b3d3@freekitty> <Pine.LNX.4.64.0701291609180.3611@woody.linux-foundation.org> <20070129161626.33277eb1@freekitty> <Pine.LNX.4.64.0701291623360.3611@woody.linux-foundation.org> <20070130065457.GA23390@elte.hu> <45BEF61F.7000400@garzik.org> <20070130075325.GA591@elte.hu> <45BEFBB2.8090402@garzik.org> <20070130080830.GC2840@elte.hu> <45C0B570.4000000@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C0B570.4000000@garzik.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -4.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-4.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0027]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Garzik <jeff@garzik.org> wrote:

> >ok. Can you suggest any way for me to reproduce such a bug 
> >artificially on a test system? [i have both old and new systems, so 
> >if you can think of a way for me to trigger this i'd be happy to try]
> 
> Should be pretty easy.  With either the old-IDE driver or libata, 
> complete a command without acknowledging an interrupt.  For libata, 
> that means poking around in ata_host_intr() and avoiding well-built 
> hardware like AHCI.  Anything that uses ata_piix driver, basically all 
> Intel machines, should be applicable in the "not well built" 
> category... :)

ok, here's one victi^H^H^H^H testbox that seems to match your 
description:

 18:          3          0   IO-APIC-fasteoi   uhci_hcd:usb3, ohci1394
 19:    2413090          0   IO-APIC-fasteoi   uhci_hcd:usb2, libata
 22:        168          0   IO-APIC-fasteoi   HDA Intel
 23:          0          0   IO-APIC-fasteoi   uhci_hcd:usb1, ehci_hcd:usb5

so i should try to generate some missing ACK [this meaning a missing 
driver-level ack, right?] on IRQ#19's libata handler - and i should 
expect a screaming interrupt? Or non-working USB? Or both?

[ i can hunt for other hardware if this doesnt look broken enough to you
  :-) ]

	Ingo
