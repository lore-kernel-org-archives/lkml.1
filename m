Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936Ab0BQJmB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 04:42:01 -0500
Received: from gate.crashing.org ([63.228.1.57]:57922 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932888Ab0BQJl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 04:41:59 -0500
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
In-Reply-To: <201002171015.52875.oliver@neukum.org>
References: <20100208065519.GE1290@ucw.cz>
	 <201002160922.47072.oliver@neukum.org> <1266397543.16346.264.camel@pasglop>
	 <201002171015.52875.oliver@neukum.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Feb 2010 20:40:09 +1100
Message-ID: <1266399609.16346.271.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-17 at 10:15 +0100, Oliver Neukum wrote:
> We should have changed the subject line.
> 
> There's a second problem. It turns out that on ARM
> mapping for DMA must not be done if PIO will be used. Some HCDs
> use PIO for some transfers but DMA for others. The generic layer
> must learn about this. 

Ah, that makes a lot of sense and the same problem would happen on
any non-DMA coherent architecture, including some embedded ppc's.

I can see why the dma unmap would invalidate the dcache and blow
away the PIO.

What bugs me here is that the dma_map_* operation should always
be done at the lowest level, ie, the actual HCD driver, and thus
it should be up to the HCD to decide whether to dma_map or not
depending on whether it's going to do DMA or not. I haven't
scrutinized USB lately but if that isn't the case and the dma_map_*
operations are done behind your back by the USB core then that needs to
be changed in a way or another, or hooked at least.

Cheers,
Ben.


