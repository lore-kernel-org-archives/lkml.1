Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab0BPIWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 03:22:48 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:34155 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab0BPIWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 03:22:47 -0500
From: Oliver Neukum <oliver@neukum.org>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Subject: Re: USB mass storage and ARM cache coherency
Date: Tue, 16 Feb 2010 09:22:47 +0100
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
References: <20100208065519.GE1290@ucw.cz> <1265628483.4020.63.camel@pc1117.cambridge.arm.com> <EAF47CD23C76F840A9E7FCE10091EFAB02C3CF7D50@dbde02.ent.ti.com>
In-Reply-To: <EAF47CD23C76F840A9E7FCE10091EFAB02C3CF7D50@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002160922.47072.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 16. Februar 2010 08:57:53 schrieb Shilimkar, Santosh:
> Continuing on the USB issue w.r.t cache coherency, the usb host
> code is violating the buffer ownership rules of streaming APIs from
> dma and non-dma transfers point if view.
> 
> We have a below temporary patch to get around the issue and probably it
> needs to be fixed in the right way in the stack because some controllers
> may not have PIO option even for control transfers. (e.g. Synopsis EHCI
> controller)

This seems wrong to me. Buffers for control transfers may be transfered
by DMA, so the caches must be flushed on architectures whose caches
are not coherent with respect to DMA.

Would you care to elaborate on the exact nature of the bug you are fixing?

	Regards
		Oliver
