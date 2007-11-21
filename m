Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbXKUUrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbXKUUrb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 15:47:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752978AbXKUUrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 15:47:21 -0500
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:16572 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754210AbXKUUrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 15:47:20 -0500
X-Belgacom-Dynamic: yes
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] USB deadlock after resume
Date: Wed, 21 Nov 2007 21:52:15 +0100
User-Agent: KMail/1.9.7
Cc: Oliver Neukum <oliver@neukum.org>, Felipe Balbi <me@felipebalbi.com>,
       Laurent Pinchart <laurentp@cse-semaphore.com>, Mark Lord <lkml@rtr.ca>,
       Markus Rechberger <mrechberger@gmail.com>, linux-kernel@vger.kernel.org
References: <d9def9db0711210642h23db950vdc0fe1b9802e3e8b@mail.gmail.com> <dd6afcb038a38716f46887681f05f367@felipebalbi.com> <200711211610.58684.oliver@neukum.org>
In-Reply-To: <200711211610.58684.oliver@neukum.org>
X-Face: 4Mf^tnii7k\_EnR5aobBm6Di[DZ9@AX1wJ"okBdX-UoJ>:SRn]c6DDU"qUIwfs98vF>=?utf-8?q?Tnf=0A=09SacR=7B?=(0Du"N%_.#X]"TXx)A'gKB1i7SK$CTLuy{h})c=g:'w3
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711212152.16066.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 November 2007, Oliver Neukum wrote:
> Am Mittwoch 21 November 2007 schrieb Felipe Balbi:
> > > Do you know any good way for performing a softreset within the driver?
> > > The video application should get a continuous datastream after
> > > resuming the notebook, so the driver shouldn't be unloaded.
> > > The driver also keeps a list of previous camera settings which should
> > > be set up again after resuming. Stopping the video application and
> > > reattaching the device using ACPI (this board supports reconnecting
> > > the device using ACPI) should be avoided.
> >
> > When you suspend, you cut off vbus (afaik, correct me if I'm wrong),
> > which means your device will get disconnected. One way to avoid this is
> > enabling CONFIG_USB_PERSIST and trying with that on.
>
> Suspend may or may not cut off power.

I've always been confused by this.

If I'm not mistaken, there are three kind of suspend modes: autosuspend, 
suspend to RAM and suspend to disk. In the first case I expect the USB hub 
(either root hub or external hub) to make the bus idle but not power it down. 
In the last case I suspect the USB bus to be powered down.

What controls the USB bus power on suspended ports ? Is it handled by the 
system (BIOS, ...) ? Is it allowed to power down the ports or keep them 
powered as it chooses ? What are the rules set in stone ?

> If it does cut off power, resume() will never be called, instead either
> disconnect() or reset_resume(). 

What is reset_resume() for ? Which one will be called on resume after a bus 
power down ?

Best regards,

Laurent Pinchart
