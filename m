Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab0BPOqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 09:46:45 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:40125 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab0BPOqo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 09:46:44 -0500
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
To: Oliver Neukum <oliver@neukum.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Catalin Marinas <catalin.marinas@arm.com>, Pavel Machek <pavel@ucw.cz>,
       Greg KH <greg@kroah.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       "Mankad, Maulik Ojas" <x0082077@ti.com>
Date: Tue, 16 Feb 2010 20:15:55 +0530
Subject: RE: USB mass storage and ARM cache coherency
Thread-Topic: USB mass storage and ARM cache coherency
Thread-Index: AcqvE4MzeiwSSWdcQPSZLgylUiXKwwAAeHIA
Message-ID: <EAF47CD23C76F840A9E7FCE10091EFAB02C3CF8073@dbde02.ent.ti.com>
References: <20100208065519.GE1290@ucw.cz>
 <201002161446.59920.oliver@neukum.org>
 <EAF47CD23C76F840A9E7FCE10091EFAB02C3CF8038@dbde02.ent.ti.com>
 <201002161522.38467.oliver@neukum.org>
In-Reply-To: <201002161522.38467.oliver@neukum.org>
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
> Sent: Tuesday, February 16, 2010 7:53 PM
> To: Shilimkar, Santosh
> Cc: Russell King - ARM Linux; Catalin Marinas; Pavel Machek; Greg KH; Matthew Dharm; Sergei Shtylyov;
> Ming Lei; Sebastian Siewior; linux-usb@vger.kernel.org; linux-kernel; linux-arm-kernel; Mankad,
> Maulik Ojas
> Subject: Re: USB mass storage and ARM cache coherency
> 
> Am Dienstag, 16. Februar 2010 15:12:45 schrieb Shilimkar, Santosh:
> > > > > I am afraid for these controllers the controller driver must be responsible
> > > > > for all DMA and cache issues. Indicating the exact requirements to the
> > > > > upper layer would be a battle already lost.
> > > > > so the safe choice is not to set has_dma and the generic layer will leave
> > > > > the issue to the lower level.
> > > > This means don't use dma at all which will almost kill the performance.
> > >
> > > Why would you be unable to map a buffer in the hcd driver when you know
> > > that you'll use DMA?
> > Probably it can be. The USB stack has the dma maintenance code at common
> > place for all controllers and hence we were just trying to see if there is
> > way to handle that way.
> 
> This is true. If you can find a clean way to describe your requirements
> to the generic layer, that would be better. The problem is that we must
> not end up with a dozen flags.
Agree 
> Your original patch however kills ehci, ohci and uhci on some architectures.
Well the patch was making _ONLY_ control transfers use PIO and rest of
the transfer would still use dma. So not sure how much performance impact would
be because of that.
Another issue with that patch is there are few controllers which can't do PIO
at all and hence the patch would broke those controllers.

So we need a clean way to handle it as you described.

Regards,
Santosh


