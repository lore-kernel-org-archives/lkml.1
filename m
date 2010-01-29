Return-Path: <linux-kernel-owner+w=401wt.eu-S1752599Ab0A2QXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab0A2QXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:23:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215Ab0A2QXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:23:07 -0500
Received: from mail-qy0-f182.google.com ([209.85.221.182]:59105 "EHLO
	mail-qy0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab0A2QXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:23:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=AAchKn0vLWdSaOJ1A+U0AGzXxydYt8VjCmlgl/We8MZSNUDdBEoALnmiRiGFQWVG53
         zQNFz5NpQW2K2cYETDCHKgPUEZowCkPFnv6Jgku0lLLfaSiY21Th8vVliTIX3qPHEmPd
         inxpdKnnE5p8cit9EpSBCtBBm9F7x6++OEboY=
MIME-Version: 1.0
In-Reply-To: <1264775655.4242.85.camel@pc1117.cambridge.arm.com>
References: <1264775655.4242.85.camel@pc1117.cambridge.arm.com>
Date: Sat, 30 Jan 2010 00:23:04 +0800
Message-ID: <d82e647a1001290823s1c651e4am113f843bef4ff9e2@mail.gmail.com>
Subject: Re: USB mass storage and ARM cache coherency
From: Ming Lei <tom.leiming@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/29 Catalin Marinas <catalin.marinas@arm.com>:
> Hi Matthew,
>
> I've been trying for some time to use a rootfs (ext2) on a USB memory
> stick on ARM platforms but without any success. The USB HCD driver is
> ISP1760 which doesn't use DMA.
>
> ARM has a Harvard cache architecture and what I get is incoherency
> between the I and D caches. The CPU I'm using (ARM11MPCore) has PIPT
> caches with D-cache lines allocation on write.
>
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

Sorry,  I am a little confused that usb mass storage has what information
about DMA or PIO of low level usb transfer?

Thanks,

-- 
Lei Ming
