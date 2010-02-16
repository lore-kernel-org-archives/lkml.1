Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab0BPOWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 09:22:39 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:42913 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391Ab0BPOWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 09:22:37 -0500
From: Oliver Neukum <oliver@neukum.org>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Subject: Re: USB mass storage and ARM cache coherency
Date: Tue, 16 Feb 2010 15:22:38 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
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
References: <20100208065519.GE1290@ucw.cz> <201002161446.59920.oliver@neukum.org> <EAF47CD23C76F840A9E7FCE10091EFAB02C3CF8038@dbde02.ent.ti.com>
In-Reply-To: <EAF47CD23C76F840A9E7FCE10091EFAB02C3CF8038@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002161522.38467.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 16. Februar 2010 15:12:45 schrieb Shilimkar, Santosh:
> > > > I am afraid for these controllers the controller driver must be responsible
> > > > for all DMA and cache issues. Indicating the exact requirements to the
> > > > upper layer would be a battle already lost.
> > > > so the safe choice is not to set has_dma and the generic layer will leave
> > > > the issue to the lower level.
> > > This means don't use dma at all which will almost kill the performance.
> > 
> > Why would you be unable to map a buffer in the hcd driver when you know
> > that you'll use DMA?
> Probably it can be. The USB stack has the dma maintenance code at common 
> place for all controllers and hence we were just trying to see if there is 
> way to handle that way.

This is true. If you can find a clean way to describe your requirements
to the generic layer, that would be better. The problem is that we must
not end up with a dozen flags.

Your original patch however kills ehci, ohci and uhci on some architectures.

	Regards
		Oliver
