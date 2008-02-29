Return-Path: <linux-kernel-owner+w=401wt.eu-S1759758AbYB2OHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759758AbYB2OHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 09:07:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754960AbYB2OGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 09:06:54 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50711 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754011AbYB2OGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 09:06:53 -0500
Date: Fri, 29 Feb 2008 13:55:56 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: devres and requesting resources
Message-ID: <20080229135556.6eafe4aa@core>
In-Reply-To: <47C7F664.5040102@garzik.org>
References: <47C75392.3020606@garzik.org>
	<20080229112651.5b2a7f6f@core>
	<47C7F664.5040102@garzik.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Only rare PCI devices are shareable among multiple drivers.

Really. Let me see
	AGP & EDAC
	Serial/Parallel combo ports
	MPIIX
	CS5520
	Lots of I2C bus stuff
	VGA v 3D

There are quite a few, and some are already quite fun enough with our pci
struct model.

> sata_* at least intentionally used pci_request_regions() because it is 
> obvious from the hardware spec that multiple regions accessed by 
> multiple drivers is highly unlikely, without the driver being 
> specifically coded to support such sharing.  Such sharing code is far 
> beyond simple resource reservation, to avoid stepping on toes when there 
> is a single MMIO region and set of interrupt clearing registers.
> 
> So reading your email it sounds like there are valid cases for both 
> configurations.
> 
> Its a design choice either way, not a bug either way.

It is a flaw: devres that assumes it should grab all resources is unusable
for some other drivers - it is no longer generic and that makes it far
less useful. I've got no problem with the idea of a devres way to say
"and I want it all, mine mine mine" but that should not be the only
behaviour.

Alan
