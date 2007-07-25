Return-Path: <linux-kernel-owner+w=401wt.eu-S933732AbXGYQph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933732AbXGYQph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 12:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762717AbXGYQpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 12:45:30 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:5545 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762675AbXGYQp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 12:45:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=K1vKdMCqTFTtzU+BvaXMrjvj8EvXI3uyEZOCZfUuv5n2rJBVYTN5SZhcph6mOWmUyzlp0iSitnSzLUasoVqSkFwuOKvKnRGae4ayjuHCQdMO4jD5i3MZHYyHHkVT5Pf5Wj2yO0Dvhb1u1gIAtAoFmOgTJyWow9UHgkYlPwu78Bc=
Message-ID: <86802c440707250945gbea89f8l85db11eab0ebffdd@mail.gmail.com>
Date: Wed, 25 Jul 2007 09:45:28 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to platform devices - broke my serial console
Cc: "Jeff Garzik" <jeff@garzik.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       "=?ISO-8859-1?Q?S=E9bastien_Dugu=E9?=" <sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <200707251011.35891.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr>
	 <200707250655.07746.bjorn.helgaas@hp.com>
	 <86802c440707250857u22e5afa3kefb06a997c38c3b8@mail.gmail.com>
	 <200707251011.35891.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/25/07, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> On Wednesday 25 July 2007 09:57:47 am Yinghai Lu wrote:
> > On 7/25/07, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > > On Tuesday 24 July 2007 10:27:26 pm Yinghai Lu wrote:
> > > > or we can make legacy_serial.force=1 is default at this point.
> > >
> > > At which point?  We already do the legacy probe if there are no
> > > PNP devices.  Do you mean we should also do the legacy probe if
> > > there are PNP devices, but no serial devices were found?  That
> > > might be reasonable to do, but wouldn't have prevented the problem
> > > on Sebastien's machine, because his machine *does* have PNP UARTs.
> >
> > but still could have problem. if the system does not have any uart,
> > and So we can not find that in DSDT...and we add legacy again...that
> > is not right.
>
> I'm sorry, I don't understand what you're saying.
>
> The behavior with my patch is: If we have PNPBIOS or ACPI, and it
> does not describe any UARTs, we assume the box has no UARTs.  If we
> don't have PNPBIOS or ACPI, we blindly probe for legacy UARTs.
>
> What behavior are you suggesting?

*** If we have PNPBIOS or ACPI, and it  does describe any UARTs, we
assume the box has no other legacy UARTs.
*** If we have PNPBIOS or ACPI, and it  does not describe any UARTs,
we blindly probe for legacy UARTs. ----------in case old box DSDT
doesn't have PNP0501 there in DSDT.
If we don't have PNPBIOS or ACPI, we blindly probe for legacy UARTs.

YH
