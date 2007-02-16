Return-Path: <linux-kernel-owner+w=401wt.eu-S1423432AbXBPJLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423432AbXBPJLX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 04:11:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423436AbXBPJLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 04:11:23 -0500
Received: from wr-out-0506.google.com ([64.233.184.227]:49766 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423432AbXBPJLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 04:11:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XSZkX5ik0Msg2LXTQCBjlr+4E+oJQkENqfh4c4zveLa9sAhNP2lTaOo4mGj6UBfTLFZMUE/nk6n8VRvt70qZ6ebrIgXOL97Z9plI5Dmytwpm9LXFGH1Beu6uXA+ezE97a6RgyPsWvTq7VPKO5eqgPx4Ay0k5xUXoaQ5PjwXjN+o=
Message-ID: <32209efe0702160111q78a32df8i70e3112e5d8da5c1@mail.gmail.com>
Date: Fri, 16 Feb 2007 02:11:20 -0700
From: "Natalie Protasevich" <protasnb@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, lenb@kernel.org
Subject: Re: FW: [PATCH] i386: irq: Kill IRQ compression
Cc: "Andi Kleen" <ak@suse.de>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
In-Reply-To: <19D0D50E9B1D0A40A9F0323DBFA04ACC023B0E20@USRV-EXCH4.na.uis.unisys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19D0D50E9B1D0A40A9F0323DBFA04ACC023B0E20@USRV-EXCH4.na.uis.unisys.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Eric W. Biederman [mailto:ebiederm@xmission.com]
> Sent: Friday, February 16, 2007 12:44 AM
> To: Len Brown
> Cc: Andi Kleen; Protasevich, Natalie; lkml - Kernel Mailing List;
> linux-acpi@vger.kernel.org
> Subject: Re: [PATCH] i386: irq: Kill IRQ compression
>
> Len Brown <lenb@kernel.org> writes:
>
> > This code makes simple systems complex:
> >
> > ACPI: PCI Interrupt 0000:03:04.0[A] -> GSI 18 (level, low) -> IRQ 16
> > ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 17
> > ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 18
> > ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 23 (level, low) -> IRQ 19
> >
> > The same code was already removed from x86_64
>
> By itself I don't think we are going to observe any real problems
> with this patch.
>
> However if we are going to be serious about this we need to do a
> few more things.
>
> - kill iopaic_renumber_irq.

This routine actually renumbers gsi's. I don't think you can kill
ioapic_renumber_irq without bringing down ES7000 that have swapped
legacy/PCI ranges and are still out there. Moreover, mach-es7000
purpose is to define and use the range swapper on the first ioapic.
Kernel still assumes legacy mapping having no overrides of that
extent. Perhaps the real fix is to have ACPI/MPS parsers to read the
actual pin/gsi information from the tables, which turned out pretty
difficult last time we tried.
--Natalie

> - Increase NR_IRQS.
>
> We will still be limited to about 208 interrupts in use at one
> time, but we can allow more irq sources to be described.
>
> This reminds me.  I really need to dig up my patch that doesn't
> allocate a vector for an irq until request irq time.
>
> Eric
>
