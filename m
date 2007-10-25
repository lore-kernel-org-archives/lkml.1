Return-Path: <linux-kernel-owner+w=401wt.eu-S1759419AbXJYU4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759419AbXJYU4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbXJYU4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:56:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:52243 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbXJYU4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:56:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=G7dilcxblCEsGD0GpHd2+8UORmUIW/GGczlCVpqNUhBNk54PSuOgKstcoowATZyKkCjjgwCj11pXX9d8xPQujfZo4yaTQqvVWIlZ8ls08Up3IEjRVa+8vC93laa7MG8RcIw0hcQezsVeR9RxLmy3XkKXhJtE+GRvzpjoQiJ8Dds=
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] [PATCH] rt2500usb - Don't claim 050d:705{0/a}
Date: Thu, 25 Oct 2007 23:15:49 +0200
User-Agent: KMail/1.9.7
Cc: Parag Warudkar <kernel-stuff@comcast.net>, linux-kernel@vger.kernel.org
References: <alpine.DEB.0.99.0710241909250.18618@parag-desktop>
In-Reply-To: <alpine.DEB.0.99.0710241909250.18618@parag-desktop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710252315.49427.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> I have a Belkin USB Wireless adapter with ID 050d:705a.
> Both rt2500usb.c and rt73usb.c claim that they can drive the device with 
> this ID.
> 
> When using the distro kernel as well as custom 2.4.24-rc1 both rt73usb and 
> rt2500usb get loaded and fight for the register writes and fail. rt2500usb 
> is not able to drive my device. So I have to manually rmmod/modprobe or 
> delete rt2500usb.ko and depmod every time I get a new kernel.
> 
> If only rt73usb is loaded everything works well. To me it 
> sounds like rt2500usb should not be driving 050d:705a.
> 
> There is another ID 050d:7050 which is also claimed to be handled by both 
> rt3500usb and rt73usb. Assuming rt73usb can drive this as well (I have no 
> way to be sure as I don't have device with this ID) the following patch 
> makes sure only rt73usb claims the 2 devices.

I awknowledge the problem, but the solution cannot be found in the USB ID's
listed in the driver. The bug is the manufacturer who changed chipset while
keeping the USB ID the same.
There are 2 possible ways around this: hacking the module loader so
it continues searching for a different driver when the first driver indicates
that it cannot control the device.
Or the easiest way, just blacklist rt2500usb if you are sure you need the rt73 driver.

Ivo
