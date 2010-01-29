Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091Ab0A2QK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab0A2QK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060Ab0A2QKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:10:46 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:47491 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041Ab0A2QKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:10:44 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: USB mass storage and ARM cache coherency
Date: Fri, 29 Jan 2010 17:10:54 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc3-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-usb@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <1264775655.4242.85.camel@pc1117.cambridge.arm.com>
In-Reply-To: <1264775655.4242.85.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201001291710.54509.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 29. Januar 2010 15:34:15 schrieb Catalin Marinas:
> Basically, when user space tries to execute from a new page, it faults
> and the data is requested via the VFS layer, SCSI block device and USB
> mass storage from the ISP1760 driver. The page is then mapped into user
> space and update_mmu_cache() called.
> 
> However, since the driver is PIO, the data copied from the USB device
> into RAM gets stuck in the D-cache. On the above page requesting path
> there is no call to flush_dcache_page() to handle D-cache maintenance
> (for DMA drivers, that's handled by the DMA API).
> 
> Since the USB mass storage code has the information about the USB driver
> capabilities (DMA or PIO), it looks like the best place to call
> flush_dcache_page(). But I got lost in the SCSI emulation and all my
> attempts failed to get a working rootfs.

No, that would be a very bad place in the layering to do this.
The problem would happen with ub and storage. It might also
happen with any other driver.
Please add this to the HCD driver.

	Regards
		Oliver
