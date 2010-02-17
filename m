Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934220Ab0BQKJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 05:09:32 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:51776 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934018Ab0BQKJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 05:09:31 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: USB mass storage and ARM cache coherency
Date: Wed, 17 Feb 2010 11:09:31 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       Ming Lei <tom.leiming@gmail.com>,
       "Mankad, Maulik Ojas" <x0082077@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>
References: <20100208065519.GE1290@ucw.cz> <201002171015.52875.oliver@neukum.org> <1266399609.16346.271.camel@pasglop>
In-Reply-To: <1266399609.16346.271.camel@pasglop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201002171109.32107.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 17. Februar 2010 10:40:09 schrieb Benjamin Herrenschmidt:
> What bugs me here is that the dma_map_* operation should always
> be done at the lowest level, ie, the actual HCD driver, and thus
> it should be up to the HCD to decide whether to dma_map or not
> depending on whether it's going to do DMA or not. I haven't
> scrutinized USB lately but if that isn't the case and the dma_map_*
> operations are done behind your back by the USB core then that needs to
> be changed in a way or another, or hooked at least.

No problem here. USB core does the mapping only if the low-level driver
so requests. The only exception is in usb_buffer_alloc(), but that boils
down to dma_alloc_coherent()

	Regards
		Oliver
