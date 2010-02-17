Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701Ab0BQKTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 05:19:51 -0500
Received: from gate.crashing.org ([63.228.1.57]:39773 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983Ab0BQKTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 05:19:49 -0500
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
In-Reply-To: <201002171109.32107.oliver@neukum.org>
References: <20100208065519.GE1290@ucw.cz>
	 <201002171015.52875.oliver@neukum.org> <1266399609.16346.271.camel@pasglop>
	 <201002171109.32107.oliver@neukum.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Feb 2010 21:18:01 +1100
Message-ID: <1266401881.16346.278.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-17 at 11:09 +0100, Oliver Neukum wrote:
> 
> No problem here. USB core does the mapping only if the low-level driver
> so requests. The only exception is in usb_buffer_alloc(), but that boils
> down to dma_alloc_coherent() 

Allright, so why do we need to "fix" anything ? Or is the whole thread
moot ? :-)

It's pretty clear that between dma_map* and subsequent unmap, the memory
is owned by the device and must not be touched by the CPU. If that is
violated, then we have a driver bug.

Cheers,
Ben.


