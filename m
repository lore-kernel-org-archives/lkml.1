Return-Path: <linux-kernel-owner+w=401wt.eu-S1757989AbXLLFtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbXLLFtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 00:49:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbXLLFtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 00:49:32 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:23516 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965AbXLLFtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 00:49:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MVOSzEXL/bPVVJdNyM0yj8hSINC23mtLSMD255X8hLLYbxGp4ol8YLrQkCsq3H5Fr1GoqPO80t5kfjGRnmSBZR0txgaJTY/uB/dpP7zgSRJ7FXX7RLL9OcRjVh1cNAf1Z+Ur7tL58KwtnLA/8BQQqaL9nbFrN4ULQG/TaUJbQ/w=
Message-ID: <86802c440712112149p5b405280xa846888fdb23d629@mail.gmail.com>
Date: Tue, 11 Dec 2007 21:49:30 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] pci: don't load acpi_php when acpi is disabled
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20071211204620.6c9acf54.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200712112014.40923.yinghai.lu@sun.com>
	 <20071211204620.6c9acf54.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 11, 2007 8:46 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 11 Dec 2007 20:14:40 -0800 Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
>
> > [PATCH] pci: don't load acpi_php when acpi is disabled
> >
> > when acpi=off and pci=nomsi, don't load acpiphp
> >
> > Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
> >
> > diff --git a/drivers/pci/hotplug/acpiphp_core.c b/drivers/pci/hotplug/acpiphp_core.c
> > index c8c2638..84d66ba 100644
> > --- a/drivers/pci/hotplug/acpiphp_core.c
> > +++ b/drivers/pci/hotplug/acpiphp_core.c
> > @@ -392,6 +392,9 @@ static int __init acpiphp_init(void)
> >  {
> >       info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
> >
> > +     if (acpi_pci_disabled)
> > +             return 0;
> > +
> >       acpiphp_debug = debug;
> >
> >       /* read all the ACPI info from the system */
> > @@ -401,6 +404,9 @@ static int __init acpiphp_init(void)
> >
> >  static void __exit acpiphp_exit(void)
> >  {
> > +     if (acpi_pci_disabled)
> > +             return 0;
> > +
> >       /* deallocate internal data structures etc. */
> >       acpiphp_glue_exit();
> >  }
>
> OK, but there is some information missing in your patch descriptions: what
> effect do these patches have?  Does the kernel crash without them?  Or is
> there no effect at all?  Or something in between?

warning when use acpi=off to disable acpi in kernel

AER service couldn't init device 0000:00:0a.0:pcie01 - no _OSC support
AER service couldn't init device 0000:00:0e.0:pcie01 - no _OSC support
AER service couldn't init device 0000:00:0f.0:pcie01 - no _OSC support
AER service couldn't init device 0000:80:0b.0:pcie01 - no _OSC support
AER service couldn't init device 0000:80:0e.0:pcie01 - no _OSC support
AER service couldn't init device 0000:80:0f.0:pcie01 - no _OSC support

pci_hotplug: PCI Hot Plug PCI Core version: 0.5
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
ACPI Exception (utmutex-0263): AE_BAD_PARAMETER, Thread
FFFF81103CC54000 could not acquire Mutex [1] [20070126]

Thanks

Yinghai Lu
