Return-Path: <linux-kernel-owner+w=401wt.eu-S1751565AbXBVJsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbXBVJsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 04:48:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbXBVJsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 04:48:12 -0500
Received: from matups.math.u-psud.fr ([129.175.50.4]:44045 "EHLO
	matups.math.u-psud.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbXBVJsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 04:48:11 -0500
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: Simon Arlott <404ba30d933f248a9b1hjz8z0007fglh@thunder.lp0.eu>
Subject: Re: [PATCH 1/2] usbatm: Increment module refcount when atm device is opened.
Date: Thu, 22 Feb 2007 10:48:00 +0100
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <45DCBB4E.8000502@simon.arlott.org.uk>
In-Reply-To: <45DCBB4E.8000502@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702221048.01623.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 February 2007 22:36:14 Simon Arlott wrote:
> Increment usbatm driver module refcount when atm device is opened,
> this prevents the driver for the device being removed if it's in use.
> (I continue to allow removing the driver without unplugging the device
> if it's not being used). No problems occur if the atm device is open
> while the device is unplugged.    

What for?  Did you see any problems with the way it works right now?
How it works now is that if the module is unloaded while the device is
in use, then the device is deregistered from the USB and ATM layers
before the module unload completes.  Thus there should be no problem
unloading the device at any moment.  I'm guessing that you want this
because of the better proc support you would like to add, which adds
an extra callback into the module.  This too should cause no problems
as long as the appropriate tweaks are made to the shutdown code.  I
plan to make those adjustments, but I didn't find time yet - sorry.

So this is a nack.

Best wishes,

Duncan.
