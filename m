Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbZG0KOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbZG0KOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 06:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755939AbZG0KOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 06:14:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41384 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755916AbZG0KOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 06:14:23 -0400
Date: Mon, 27 Jul 2009 11:15:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: gregkh@suse.de, linux-usb@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RFC] ark3116: add IrDA support (for Gembird UIR-22)
Message-ID: <20090727111515.7d5f359f@lxorguk.ukuu.org.uk>
In-Reply-To: <200907261419.50702.linux@rainbow-software.org>
References: <200907261419.50702.linux@rainbow-software.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The next step was usbsnoop to find what windows driver does with the device.
> The result is the patch below. Now the device works after plugging and running
> "irattach /dev/ttyUSB0 -s".
> 
> But how to make it appear as a real IrDA device by itself? Another problem is
> mixing IrDA with USB serial driver. Is a separate driver (something like
> ark3116-irda) needed?

For standard devices using serial/tty then irattach is the right way to
do it. Nothing else should be needed.

> +	irda = le16_to_cpu(serial->dev->descriptor.idProduct) == 0x3118;
> +	if (irda)
> +		dbg("IrDA mode");
> +

I would split this out into

static int is_irda(serial) { }

just so that anyone who needs to add more irda adapters can find it
easily and do so neatly.

Alan
