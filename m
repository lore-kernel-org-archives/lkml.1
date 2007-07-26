Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbXGZAhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbXGZAhn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 20:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbXGZAhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 20:37:34 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:45838 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbXGZAhc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 20:37:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NlDUL8ZoH1UC9uWlBp0R0HE0Smpi9DXMJNljZIAWOEbQnz03xo3iodwJRjg/HQ48ycJfl5r583qeSN5AlNkF1e8+DwxtYHu/8K9ZrA918jHkqA4qCbqZew3wSC8VwB/8tlIkBRpWhlFaZb4MuLDgf+jhlbes2jNurTN8ZXyA+2g=
Message-ID: <86802c440707251737p3be3ae69qe3f91282bec8984a@mail.gmail.com>
Date: Wed, 25 Jul 2007 17:37:32 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to platform devices - broke my serial console
Cc: "=?ISO-8859-1?Q?S=E9bastien_Dugu=E9?=" <sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, ambx1@neo.rr.com,
       akpm@linux-foundation.org, lenb@kernel.org, rmk@arm.linux.org.uk,
       mjg59@srcf.ucam.org, castet.matthieu@free.fr, shaohua.li@intel.com
In-Reply-To: <200707251641.23406.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr>
	 <200707250716.44609.bjorn.helgaas@hp.com>
	 <20070725153253.4d7e7e37@frecb000686.frec.bull.fr>
	 <200707251641.23406.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/25/07, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> On Wednesday 25 July 2007 07:32:53 am Sébastien Dugué wrote:
> > On Wed, 25 Jul 2007 07:16:44 -0600 Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> >
> > > The _DDN is a "DOS device name", and the _UID is a "logical device ID
> > > that does not change across reboots."  Both are optional, and PNPACPI
> > > ignores them.  But maybe we could change PNPACPI to sort by them if
> > > they are present.  I'll think about this a bit.
> >
> >   That would be nice, but I wish you good luck with all those
> > crappy BIOSes out there.
>
> Yeah, it's an ugly world we live in.  Would you be able to try the
> attached patch just for testing?  It should sort devices with the
> same _HID by their _UID.  It doesn't have any effect on my systems,
> because my devices are already ordered by _UID by default.  But I
> think it should switch your COM1/COM2 ports back to the order you
> expect.
>
> Yinghai, you mentioned the same issue on boxes with multiple root
> bridges.  Any chance you could try this out there as well?
>
it doesn't solve pci_root_bus reverse problem.

is that too late for PNP0A03?

I wonder if we need to modify acpi_device_register to sort them.

YH
