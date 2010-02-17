Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119Ab0BQMSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 07:18:09 -0500
Received: from gate.crashing.org ([63.228.1.57]:50087 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043Ab0BQMSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 07:18:06 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Ming Lei <tom.leiming@gmail.com>,
       "Mankad, Maulik Ojas" <x0082077@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <201002171123.30389.oliver@neukum.org>
References: <20100208065519.GE1290@ucw.cz>
	 <201002171109.32107.oliver@neukum.org> <1266401881.16346.278.camel@pasglop>
	 <201002171123.30389.oliver@neukum.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Feb 2010 23:15:41 +1100
Message-ID: <1266408941.16346.283.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-17 at 11:23 +0100, Oliver Neukum wrote:
> 
> The request a low-level driver does is all or nothing. Either DMA
> issues have to be handled by that driver alone, or a finer-grained
> description of the DMA requirements is needed. A fix using the latter
> approach is being worked on. 

Well, that's what I'm trying to understand.

IE. It's a pretty strong rule ... don't do CPU accesses between dma_map
and unmap. So it's all in driver land at that stage. I'm not sure how
the DMA requirements get into the picture here. IE. That rule is
globally true. It's not going to hurt just non-coherent archs, it's
going to hurt anybody using swiotlb too... So I don't see you need more
info about the DMA requirements, but maybe I did miss something :-)

Cheers,
Ben.

