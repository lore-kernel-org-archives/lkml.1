Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbXKUUg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbXKUUg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 15:36:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbXKUUgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 15:36:18 -0500
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:30393 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753211AbXKUUgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 15:36:17 -0500
X-Belgacom-Dynamic: yes
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] USB deadlock after resume
Date: Wed, 21 Nov 2007 21:41:12 +0100
User-Agent: KMail/1.9.7
Cc: "Markus Rechberger" <mrechberger@gmail.com>,
       "Oliver Neukum" <oliver@neukum.org>,
       Laurent Pinchart <laurentp@cse-semaphore.com>, Mark Lord <lkml@rtr.ca>,
       linux-kernel@vger.kernel.org
References: <d9def9db0711201347u2786fe0ev96b2fb43fc2954e9@mail.gmail.com> <200711211615.14829.oliver@neukum.org> <d9def9db0711210725x3fe35fedlc67cf637bc9ad27f@mail.gmail.com>
In-Reply-To: <d9def9db0711210725x3fe35fedlc67cf637bc9ad27f@mail.gmail.com>
X-Face: 4Mf^tnii7k\_EnR5aobBm6Di[DZ9@AX1wJ"okBdX-UoJ>:SRn]c6DDU"qUIwfs98vF>=?utf-8?q?Tnf=0A=09SacR=7B?=(0Du"N%_.#X]"TXx)A'gKB1i7SK$CTLuy{h})c=g:'w3
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711212141.13102.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 November 2007, Markus Rechberger wrote:
> On 11/21/07, Oliver Neukum <oliver@neukum.org> wrote:
> > Am Mittwoch 21 November 2007 schrieb Markus Rechberger:
> > > > Which URB is usb_kill_urb() called for?
> > >
> > > it's the usb_control_message which calls usb_kill_urb if I haven't got
> > > it wrong. (if you're looking for some other information please let me
> > > know)
> > > Although, I got a bit further with it. The error seems to happen
> > > earlier already.
> > > If I load the driver, and do not access the device after suspending
> > > all usb_control commands fail with -71 eproto.
> >
> > A timeout. You should add the RESET_RESUME quirk for your device.
> > usb_reset_device() from resume() is not a good idea.
>
> ok this is good to know, although I have to stick with kernel 2.6.21.3
> here. It's Laurent's driver best would be to check for the specific
> kernelversion and do whatever is appropriate.

I like the RESET_RESUME quirk best. Adding a new quirk to the uvcvideo driver 
doesn't really make sense when the USB subsystem is already able to handle 
this situation.

Best regards,

Laurent Pinchart
