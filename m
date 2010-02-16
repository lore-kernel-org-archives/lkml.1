Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab0BPNc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 08:32:59 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:50379 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936Ab0BPNc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 08:32:57 -0500
From: Oliver Neukum <oliver@neukum.org>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: USB mass storage and ARM cache coherency
Date: Tue, 16 Feb 2010 14:32:57 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
       Catalin Marinas <catalin.marinas@arm.com>, Pavel Machek <pavel@ucw.cz>,
       Greg KH <greg@kroah.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
       "Mankad, Maulik Ojas" <x0082077@ti.com>
References: <20100208065519.GE1290@ucw.cz> <201002161007.20576.oliver@neukum.org> <20100216093946.GA13884@n2100.arm.linux.org.uk>
In-Reply-To: <20100216093946.GA13884@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002161432.57705.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 16. Februar 2010 10:39:46 schrieb Russell King - ARM Linux:
> However, because ARM CPUs can now speculatively prefetch, just leaving it
> at that results in corruption of buffers used for DMA.  So we have to
> invalidate DMA_FROM_DEVICE and DMA_BIDIRECTIONAL buffers on unmap to
> ensure coherency with DMA operations.
> 
> If the CPU writes to a DMA_FROM_DEVICE buffer between map and unmap, the
> writes can sit in the cache, and on unmap, they will be discarded.
> 
> Cleaning the cache on unmap is not an option; that too can lead to DMA
> buffer corruption in the DMA case.

I am afraid for these controllers the controller driver must be responsible
for all DMA and cache issues. Indicating the exact requirements to the
upper layer would be a battle already lost.
so the safe choice is not to set has_dma and the generic layer will leave
the issue to the lower level.

	Regards
		Oliver
