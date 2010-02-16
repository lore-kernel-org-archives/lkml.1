Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab0BPI4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 03:56:39 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:34789 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab0BPI4h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 03:56:37 -0500
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
To: Oliver Neukum <oliver@neukum.org>
CC: Catalin Marinas <catalin.marinas@arm.com>, Pavel Machek <pavel@ucw.cz>,
       Greg KH <greg@kroah.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       "Mankad, Maulik Ojas" <x0082077@ti.com>
Date: Tue, 16 Feb 2010 14:25:55 +0530
Subject: RE: USB mass storage and ARM cache coherency
Thread-Topic: USB mass storage and ARM cache coherency
Thread-Index: Acqu4T9C99FxKmuETmi0LpjAfLa8oAAAqTsw
Message-ID: <EAF47CD23C76F840A9E7FCE10091EFAB02C3CF7DBB@dbde02.ent.ti.com>
References: <20100208065519.GE1290@ucw.cz>
 <1265628483.4020.63.camel@pc1117.cambridge.arm.com>
 <EAF47CD23C76F840A9E7FCE10091EFAB02C3CF7D50@dbde02.ent.ti.com>
 <201002160922.47072.oliver@neukum.org>
In-Reply-To: <201002160922.47072.oliver@neukum.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Oliver Neukum [mailto:oliver@neukum.org]
> Sent: Tuesday, February 16, 2010 1:53 PM
> To: Shilimkar, Santosh
> Cc: Catalin Marinas; Pavel Machek; Greg KH; Russell King - ARM Linux; Matthew Dharm; Sergei Shtylyov;
> Ming Lei; Sebastian Siewior; linux-usb@vger.kernel.org; linux-kernel; linux-arm-kernel; Mankad,
> Maulik Ojas
> Subject: Re: USB mass storage and ARM cache coherency
> 
> Am Dienstag, 16. Februar 2010 08:57:53 schrieb Shilimkar, Santosh:
> > Continuing on the USB issue w.r.t cache coherency, the usb host
> > code is violating the buffer ownership rules of streaming APIs from
> > dma and non-dma transfers point if view.
> >
> > We have a below temporary patch to get around the issue and probably it
> > needs to be fixed in the right way in the stack because some controllers
> > may not have PIO option even for control transfers. (e.g. Synopsis EHCI
> > controller)
> 
> This seems wrong to me. Buffers for control transfers may be transfered
> by DMA, so the caches must be flushed on architectures whose caches
> are not coherent with respect to DMA.
Indeed and that's what I mentioned in the comment. But we shouldn't have dma 
cache maintenance operations done for the buffers which would use pio based transfer. 
> Would you care to elaborate on the exact nature of the bug you are fixing?
On the OMAP4 (ARM cortex-a9) platform, the enumeration fails because control
transfer buffers are corrupted. On our platform, we use PIO mode for control 
transfers and DMA for bulk transfers.

The current stack performs dma cache maintenance even for the PIO transfers
which leads to the corruption issue. The control buffers are handled by CPU 
and they already coherent from CPU point of view.


Regards,
Santosh

