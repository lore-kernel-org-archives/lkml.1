Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab0BRHPU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 02:15:20 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:57061 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab0BRHPS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 02:15:18 -0500
From: "Gadiyar, Anand" <gadiyar@ti.com>
To: Oliver Neukum <oliver@neukum.org>
CC: Alan Stern <stern@rowland.harvard.edu>,
       "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
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
Date: Thu, 18 Feb 2010 12:44:21 +0530
Subject: RE: USB mass storage and ARM cache coherency
Thread-Topic: USB mass storage and ARM cache coherency
Thread-Index: AcqwZ3ya621nT6e8RxWaij14M13MAwAAQU9g
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB03215B106B@dbde02.ent.ti.com>
References: <EAF47CD23C76F840A9E7FCE10091EFAB02C3CF84D1@dbde02.ent.ti.com>
 <Pine.LNX.4.44L0.1002171201190.1913-100000@iolanthe.rowland.org>
 <5A47E75E594F054BAF48C5E4FC4B92AB03216236D6@dbde02.ent.ti.com>
 <201002180756.14100.oliver@neukum.org>
In-Reply-To: <201002180756.14100.oliver@neukum.org>
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

Oliver Neukum wrote:
> Am Mittwoch, 17. Februar 2010 21:30:24 schrieb Gadiyar, Anand:
> > > Why do you skip mapping the setup packet but not the data packet?
> > > 
> > 
> > I think that's oversight. For this controller, we need to skip mapping
> > all buffers used to do transfers on EP0, which is all control transfers.
> 
> One thing more. Do you have an issue with EP 0 only or all control
> endpoints? EP 0 must be control, but devices are within spec if they
> have multiple control endpoints provided EP 0 is control.

Sorry for the confusion. The issue is not with EP 0 of devices
connected to the controller; the problem is with EP 0 on the host
controller itself.

The controller in question is the MUSB OTG controller present in
OMAPs, Davinci chips, and some Blackfins. The MUSB HCD driver is
written such that it carries out all control transfers on EP 0 of
the controller. All bulk transfers are carried out on other hardware
endpoints.

(This is the same "hardware endpoint" that is used in when the MUSB
is used in gadget mode.)


I'm not really sure why EP0 was chosen for control transfers, or
if there is a restriction that we *need* to use it. Let me study
the docs some more.

The problem is that with the driver code as written today, we use
EP 0 for all control transfers, and the DMA engine cannot do DMA
to this endpoint's FIFO.

- Anand
