Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab0BPJHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 04:07:23 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:55112 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891Ab0BPJHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 04:07:19 -0500
From: Oliver Neukum <oliver@neukum.org>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Subject: Re: USB mass storage and ARM cache coherency
Date: Tue, 16 Feb 2010 10:07:20 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Catalin Marinas <catalin.marinas@arm.com>, Pavel Machek <pavel@ucw.cz>,
       Greg KH <greg@kroah.com>,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
       "Mankad, Maulik Ojas" <x0082077@ti.com>
References: <20100208065519.GE1290@ucw.cz> <201002160922.47072.oliver@neukum.org> <EAF47CD23C76F840A9E7FCE10091EFAB02C3CF7DBB@dbde02.ent.ti.com>
In-Reply-To: <EAF47CD23C76F840A9E7FCE10091EFAB02C3CF7DBB@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002161007.20576.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 16. Februar 2010 09:55:55 schrieb Shilimkar, Santosh:
> > This seems wrong to me. Buffers for control transfers may be transfered
> > by DMA, so the caches must be flushed on architectures whose caches
> > are not coherent with respect to DMA.
> Indeed and that's what I mentioned in the comment. But we shouldn't have dma 
> cache maintenance operations done for the buffers which would use pio based transfer.

Given that the generic layer can't know which buffers will be used for DMA
that would require a callback into the hcd driver.

> > Would you care to elaborate on the exact nature of the bug you are fixing?
> On the OMAP4 (ARM cortex-a9) platform, the enumeration fails because control
> transfer buffers are corrupted. On our platform, we use PIO mode for control 
> transfers and DMA for bulk transfers.
> 
> The current stack performs dma cache maintenance even for the PIO transfers
> which leads to the corruption issue. The control buffers are handled by CPU 
> and they already coherent from CPU point of view.

How does the mapping corrupt buffers? It might impact performance, but why
do you see corruption?

	Regards
		Oliver
