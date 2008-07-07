Return-Path: <linux-kernel-owner+w=401wt.eu-S1755130AbYGGLn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbYGGLn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 07:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbYGGLns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 07:43:48 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64431 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752945AbYGGLnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 07:43:47 -0400
Date: Mon, 7 Jul 2008 12:41:53 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       linux-next@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/2] acpi: Disable IRQ 0 through I/O APIC for some HP
 systems
In-Reply-To: <20080707071706.GA3326@elte.hu>
Message-ID: <Pine.LNX.4.55.0807071224491.16767@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0807010055070.30785@cliff.in.clinika.pl>
 <20080701202453.GD4896@elte.hu> <200807070102.38854.rjw@sisk.pl>
 <200807070319.29470.rjw@sisk.pl> <20080707071706.GA3326@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jul 2008, Ingo Molnar wrote:

> > Please note two things:
> > (1) The whole acpi_dmi_table[] thing originally depended on __i386__, so it
> >     wouldn't work on x86-64 no matter what.  I removed that dependecy, but
> >     I have no idea why it was there and so I'm not sure if that's correct. 

 Well spottedd -- perhaps the x86-64 was though to be perfect. ;)

> > (2) The clear_IO_APIC_pin(apic1, pin1) done if 
> >     disable_irq0_through_ioapic is true is absolutely essential.  The 
> >     symptoms are 100% reproducible without it.
> 
> thanks, applied to tip/x86, to give this some more testing.
> 
> the clear_IO_APIC_pin() is the most worrisome aspect of the change - but 
> since we are already in limited quirk mode, does it hurt? Maciej, any 
> preferences?

 It makes absolutely no sense and should be harmful to call
clear_IO_APIC_pin(apic1, pin1) here, because both apic1 and pin1 should be
equal to -1 here.  If it has to be called, then I suppose the DMI matching 
did not work and the workaround has not been enabled.

 Rafael, can you please provide a full bootstrap log obtained with all the
changes, but *without* this part?  Also, can you please verify DMI IDs of
your system (dmidecode or /sys/class/dmi, I am told)?

 I do think we should record DMI vendor and name information in the
bootstrap log.  It won't take a lot of space and will be more useful than
some other IDs we never use for anything else, which we obtain from some
other tables.

  Maciej
