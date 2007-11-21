Return-Path: <linux-kernel-owner+w=401wt.eu-S1760883AbXKUPPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760883AbXKUPPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 10:15:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbXKUPPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 10:15:09 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:53355 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbXKUPPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 10:15:08 -0500
From: Oliver Neukum <oliver@neukum.org>
To: "Markus Rechberger" <mrechberger@gmail.com>
Subject: Re: USB deadlock after resume
Date: Wed, 21 Nov 2007 16:15:14 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Mark Lord" <lkml@rtr.ca>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net,
       "Laurent Pinchart" <laurentp@cse-semaphore.com>
References: <d9def9db0711201347u2786fe0ev96b2fb43fc2954e9@mail.gmail.com> <200711211246.39441.oliver@neukum.org> <d9def9db0711210637x6fd5ad09o549b787639690d55@mail.gmail.com>
In-Reply-To: <d9def9db0711210637x6fd5ad09o549b787639690d55@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711211615.14829.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 21 November 2007 schrieb Markus Rechberger:
> > Which URB is usb_kill_urb() called for?
> >
> 
> it's the usb_control_message which calls usb_kill_urb if I haven't got
> it wrong. (if you're looking for some other information please let me
> know)
> Although, I got a bit further with it. The error seems to happen
> earlier already.
> If I load the driver, and do not access the device after suspending
> all usb_control commands fail with -71 eproto.

A timeout. You should add the RESET_RESUME quirk for your device.
usb_reset_device() from resume() is not a good idea.

	Regards
		Oliver

