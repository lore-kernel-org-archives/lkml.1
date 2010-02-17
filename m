Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933982Ab0BQDVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 22:21:45 -0500
Received: from mail-qy0-f178.google.com ([209.85.221.178]:44097 "EHLO
	mail-qy0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933958Ab0BQDVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 22:21:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xA+mVWPXkD0Vz12gsqFaGW35q3GcNlV6tN/a6rBY8qQs6QOM7h3QPT0pNBBvaO/RLC
         ezq7GBwLNYFxGFmCVnOl655X5tVf6GLoEiBUpBkHNaNXAyu+1/JCMOjmZa0yQHy98SJn
         MG9nl0eKPThBul9jthbMN/3txzlLMtrErxh90=
MIME-Version: 1.0
In-Reply-To: <EAF47CD23C76F840A9E7FCE10091EFAB02C3CF7DBB@dbde02.ent.ti.com>
References: <20100208065519.GE1290@ucw.cz>
	 <1265628483.4020.63.camel@pc1117.cambridge.arm.com>
	 <EAF47CD23C76F840A9E7FCE10091EFAB02C3CF7D50@dbde02.ent.ti.com>
	 <201002160922.47072.oliver@neukum.org>
	 <EAF47CD23C76F840A9E7FCE10091EFAB02C3CF7DBB@dbde02.ent.ti.com>
Date: Wed, 17 Feb 2010 11:21:41 +0800
Message-ID: <d82e647a1002161921l669e08bficafc0c2bc5433cb3@mail.gmail.com>
Subject: Re: USB mass storage and ARM cache coherency
From: Ming Lei <tom.leiming@gmail.com>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Cc: Oliver Neukum <oliver@neukum.org>,
       Catalin Marinas <catalin.marinas@arm.com>, Pavel Machek <pavel@ucw.cz>,
       Greg KH <greg@kroah.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       "Mankad, Maulik Ojas" <x0082077@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/2/16 Shilimkar, Santosh <santosh.shilimkar@ti.com>:

>> > We have a below temporary patch to get around the issue and probably it
>> > needs to be fixed in the right way in the stack because some controllers
>> > may not have PIO option even for control transfers. (e.g. Synopsis EHCI
>> > controller)

Your temporary patch only removes dma map and umap for setup buffer in
control transfer.

>>
>> This seems wrong to me. Buffers for control transfers may be transfered
>> by DMA, so the caches must be flushed on architectures whose caches
>> are not coherent with respect to DMA.
> Indeed and that's what I mentioned in the comment. But we shouldn't have dma
> cache maintenance operations done for the buffers which would use pio based transfer.
>> Would you care to elaborate on the exact nature of the bug you are fixing?
> On the OMAP4 (ARM cortex-a9) platform, the enumeration fails because control
> transfer buffers are corrupted. On our platform, we use PIO mode for control
> transfers and DMA for bulk transfers.

I don't know you mean you use PIO mode for seup buffer only or whole control
transfer(setup sent, data in or data out).  If you mean do not use DMA
for setup sent, data in or data out in a control transfer, your
temporary patch maybe is not enough, right?

>
> The current stack performs dma cache maintenance even for the PIO transfers
> which leads to the corruption issue. The control buffers are handled by CPU
> and they already coherent from CPU point of view.

-- 
Lei Ming
