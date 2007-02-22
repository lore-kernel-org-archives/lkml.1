Return-Path: <linux-kernel-owner+w=401wt.eu-S1751334AbXBVR04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334AbXBVR04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 12:26:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbXBVR0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 12:26:55 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37479 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751334AbXBVR0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 12:26:54 -0500
Date: Thu, 22 Feb 2007 18:29:39 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Robert Hancock <hancockr@shaw.ca>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI driver support for pata
Message-ID: <20070222182939.56d43a68@lxorguk.ukuu.org.uk>
In-Reply-To: <45DDCEC4.7050208@garzik.org>
References: <fa.IjFXvdcBtWXV65pRZipPd0NVTOA@ifi.uio.no>
	<45DD2E12.6000705@shaw.ca>
	<45DD3F20.7050907@pobox.com>
	<20070222142439.50cff3e9@lxorguk.ukuu.org.uk>
	<45DDCEC4.7050208@garzik.org>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Feb 2007 12:11:32 -0500
Jeff Garzik <jeff@garzik.org> wrote:

> Alan wrote:
> > ACPI is the only way to do cable handling on the Nvidia PATA chipset. The
> 
> You failed to quote the salient part of the message.  Disliking a 
> separate pata_acpi driver in no way invalidates your statement (quoted 
> above).

If you drive a device by the ACPI interface you don't get to fiddle with
it directly or you end up in a murky world of undefined and ungood
behaviour. Testing and vendor information both say pata_acpi is the right
way to drive Nvidia PATA ports.

Cable problem appears to be that
- Tejun fixed the drive side detect logic to be stricter and correct
- Large numbers of controllers with host side detect don't do drive side
detect

Changing the code to clip rates only for 40wire or unknown cables
improves the behaviour.

In the ACPI case I found another corner case with one BIOS which chooses
to boot in PIO mode and which therefore fooled the cable detect trick
used by pata_acpi. It now does further cable checking in ->mode_filter
which combined with the patch in -mm to do the cable logic last means it
works for that case too.

Alan
