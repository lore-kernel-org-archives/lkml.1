Return-Path: <linux-kernel-owner+w=401wt.eu-S1756391AbYGGSB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbYGGSB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 14:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbYGGSBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 14:01:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34012 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981AbYGGSBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 14:01:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH 2/2] acpi: Disable IRQ 0 through I/O APIC for some HP systems
Date: Mon, 7 Jul 2008 20:03:47 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       linux-next@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
References: <Pine.LNX.4.55.0807010055070.30785@cliff.in.clinika.pl> <200807071423.48425.rjw@sisk.pl> <Pine.LNX.4.55.0807071435160.16767@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0807071435160.16767@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807072003.48228.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 7 of July 2008, Maciej W. Rozycki wrote:
> On Mon, 7 Jul 2008, Rafael J. Wysocki wrote:
> 
> > >  It makes absolutely no sense and should be harmful to call
> > > clear_IO_APIC_pin(apic1, pin1) here, because both apic1 and pin1 should be
> > > equal to -1 here.  If it has to be called, then I suppose the DMI matching 
> > > did not work and the workaround has not been enabled.
> > 
> > Do you realize that the clear_IO_APIC_pin(apic1, pin1) thing is _only_ called
> > _IF_ the DMI matching did work?
> 
>  Well, it is the very intent of the DMI quirk to set apic1 and pin1 both
> to -1, as a result of IRQ0 being absent from our I/O APIC interrupt
> routing table.  Therefore if the quirk did indeed work, a call to
> clear_IO_APIC_pin() is useless and likely harmful as its callees don't do
> range checking (my understanding of code is it results in random poking at
> the local APIC through the FIX_APIC_BASE fixmap).  There should be nothing
> to clear too, as interrupt redirection entries for all the I/O APIC inputs
> are cleared (the mask is set to 1 and the remaining fields zeroed) when
> clear_IO_APIC() is called from enable_IO_APIC() upon initialization and
> all the unused ones (not referred to from anywhere in the interrupt
> routing table) are never touched afterwards.

Sorry, the patch I posted was _instead_ of your previous patch with the quirk,
because that patch didn't work.  I don't know why it didn't work, however, I
can only say it didn't work after removing the __i386__ dependency of
acpi_dmi_table[].

My patch is on top of the linux-next tree that didn't contain your patch.
So, my patch adds a quirk that sets disable_irq0_through_ioapic to 1 (this
variable is defined differently in my patch) and uses it to skip the part of
check_timer() that breaks my box.

I hope that makes things clear.

Thanks,
Rafael
