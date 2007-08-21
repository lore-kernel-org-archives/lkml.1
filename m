Return-Path: <linux-kernel-owner+w=401wt.eu-S1758469AbXHUMle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758469AbXHUMle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 08:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbXHUMl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 08:41:26 -0400
Received: from mx1.ciphirelabs.net ([217.72.114.64]:59864 "EHLO
	mx.dmz.ciphirelabs.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbXHUMlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 08:41:25 -0400
From: "Andreas Jellinghaus [c]" <aj@ciphirelabs.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [linux-usb-devel] why was MODALIAS removed from usb kernel events? [u]
Date: Tue, 21 Aug 2007 14:41:14 +0200
User-Agent: KMail/1.9.6
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
References: <200708171622.05115.aj@ciphirelabs.com> <20070821073656.GA6691@kroah.com> <1187696468.2489.10.camel@lov.localdomain>
In-Reply-To: <1187696468.2489.10.camel@lov.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708211441.15645.aj@ciphirelabs.com>
X-Ciphire-Security: plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, the patch works great!
would be nice if it could be send to the stable team as well
(I think a number of distributions want to use 2.6.22 as base
for there next release, and I would be happy if users had the patch
in it).

sorry for creating confusion: initially I thought MODALIAS had been removed,
as I looked at the event with DEVICE and in 2.6.21 it has MODALIAS= and in 
2.6.22 it doesn't. that was wrong, I should have looked at the MODALIAS event
to find out that DEVICE, TYPE and PRODUCT where missing. sorry again.

> Andreas, do I read this right, you miss:
>   DEVICE, PRODUCT, TYPE
> in the usb-interface event, and they only exist in the usb-device event?

yes, in 2.6.21 two events have DEVICE (one of them has also MODALIAS), in 
2.6.22 one event has DEVICE and PRODUCT and TYPE, the other one MODALIAS,
no event has both. your patch fixes this, thanks!

> +#ifdef CONFIG_USB_DEVICEFS

does this depend on USB_CLASS_DEVICE? i.e. will it break if USB_CLASS_DEVICE
is turned off? a migration plan / what shall I do so my code still works
when that is done, would be very nice. and enough time so I can get new
versions out to the users. so far the kernel was faster and I got bug reports
about openct not working with 2.6.22 :(

Regards, Andreas
