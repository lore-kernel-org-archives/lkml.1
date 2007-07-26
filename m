Return-Path: <linux-kernel-owner+w=401wt.eu-S1758368AbXGZBfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368AbXGZBfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 21:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbXGZBfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 21:35:45 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:42261 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646AbXGZBfo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 21:35:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JSJKlE80WHBmSmQNVN65q0eMSIWU+VdqJ5VfPmncZrJVEXNAomMeXo6fwg8VGFR6StRTIpDBYWfvCqdRQCW/6pjeXEN2cfvot85mhQTZayVs9yDGhxOYjAtyKIX3IFbCpHGcYnwFgZP5ufCm4xEoY3tVoNJcMeSahnC+FuEChGw=
Message-ID: <86802c440707251835p7a1522aejbea949f2148b51fc@mail.gmail.com>
Date: Wed, 25 Jul 2007 18:35:43 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to platform devices - broke my serial console
Cc: "=?ISO-8859-1?Q?S=E9bastien_Dugu=E9?=" <sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, ambx1@neo.rr.com,
       akpm@linux-foundation.org, lenb@kernel.org, rmk@arm.linux.org.uk,
       mjg59@srcf.ucam.org, castet.matthieu@free.fr, shaohua.li@intel.com
In-Reply-To: <86802c440707251737p3be3ae69qe3f91282bec8984a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr>
	 <200707250716.44609.bjorn.helgaas@hp.com>
	 <20070725153253.4d7e7e37@frecb000686.frec.bull.fr>
	 <200707251641.23406.bjorn.helgaas@hp.com>
	 <86802c440707251737p3be3ae69qe3f91282bec8984a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/25/07, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On 7/25/07, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > On Wednesday 25 July 2007 07:32:53 am Sébastien Dugué wrote:
> > > On Wed, 25 Jul 2007 07:16:44 -0600 Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > >
> > > > The _DDN is a "DOS device name", and the _UID is a "logical device ID
> > > > that does not change across reboots."  Both are optional, and PNPACPI
> > > > ignores them.  But maybe we could change PNPACPI to sort by them if
> > > > they are present.  I'll think about this a bit.
> > >
> > >   That would be nice, but I wish you good luck with all those
> > > crappy BIOSes out there.
> >
> > Yeah, it's an ugly world we live in.  Would you be able to try the
> > attached patch just for testing?  It should sort devices with the
> > same _HID by their _UID.  It doesn't have any effect on my systems,
> > because my devices are already ordered by _UID by default.  But I
> > think it should switch your COM1/COM2 ports back to the order you
> > expect.
> >
> > Yinghai, you mentioned the same issue on boxes with multiple root
> > bridges.  Any chance you could try this out there as well?
> >
> it doesn't solve pci_root_bus reverse problem.
>
> is that too late for PNP0A03?
>
> I wonder if we need to modify acpi_device_register to sort them.

local hack for pci_root reverse problem would be

 or in acpi_pci_register_driver, sort the acpi_pci_roots before using it.

YH
