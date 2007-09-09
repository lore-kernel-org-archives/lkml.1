Return-Path: <linux-kernel-owner+w=401wt.eu-S1752788AbXIIWKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbXIIWKb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 18:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbXIIWKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 18:10:23 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:42429 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbXIIWKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 18:10:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Nvxj0wEM04+TPoscvN4x/HEWpEJFP7ttrXd314/X/dZOyOdZWkva2wAAlTNdWLgiyU4sYq30UflbYe5cZL7UCMaT4IU16KkRzfyjrGtGxGfiwa514dtDLbn5+vbPC5phYKSBdoTOg5NlYuwGAU9k8rSKJJKyZ8yUrp96gGAvpEE=
Message-ID: <e9c3a7c20709091510i723ca2b8sb08b3b1f9d4e031a@mail.gmail.com>
Date: Sun, 9 Sep 2007 15:10:12 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Timur Tabi" <timur@freescale.com>
Subject: Re: [PATCH 5/5] Add DMA engine driver for Freescale MPC85xx processors.
Cc: "Zhang Wei" <wei.zhang@freescale.com>, shannon.nelson@intel.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org
In-Reply-To: <46E46A3F.2050708@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11891624582950-git-send-email-wei.zhang@freescale.com>
	 <e9c3a7c20709091053u607e710ay1eb76c53312706ea@mail.gmail.com>
	 <46E46A3F.2050708@freescale.com>
X-Google-Sender-Auth: 54825c0e941469f0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/9/07, Timur Tabi <timur@freescale.com> wrote:
> Dan Williams wrote:
>
> > This routine implies that there is a piece of code somewhere that
> > wants to select which channels it can use.  A similar effect can be
> > achieved by registering a dma_client with the dmaengine interface
> > ('dma_async_client_register').  Then when the client code makes a call
> > to 'dma_async_client_chan_request' it receives a 'dma_event_callback'
> > for each channel in the system.  It will also be asynchronously
> > notified of channels entering and leaving the system.  The goal is to
> > share a common infrastructure for channel management.
>
> Are you familiar with the "flat device tree" used for PowerPC systems?  The
> "piece of code somewhere" is the device tree subsystem that parses the device
> tree, which is compiled from the .dts files in arch/powerpc/boot/dts.
>
> The FDT is how PowerPC systems specify hardware configuration.  In the case of
> 85xx, the FDT contains entries for each DMA device (typically 2), and the
> entries contain sub-entries for each DMA channel as well as the address of the
> register sets for each channel.
>
Ahh, ok then this code is replacing what would normally be handled by
the PCI bus enumeration code, or the platform device registrations for
iop-adma in arch/arm/mach-iop13xx.  Sorry for the noise with this
comment.

> --
> Timur Tabi
> Linux Kernel Developer @ Freescale
> -

Thanks,
Dan
