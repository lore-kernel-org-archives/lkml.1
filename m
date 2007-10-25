Return-Path: <linux-kernel-owner+w=401wt.eu-S1755193AbXJYUBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbXJYUBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759469AbXJYUBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:01:41 -0400
Received: from ranger.systems.pipex.net ([62.241.162.32]:52945 "EHLO
	ranger.systems.pipex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759013AbXJYUBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:01:39 -0400
X-Greylist: delayed 1572 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Oct 2007 16:01:38 EDT
From: Adam Baker <linux@baker-net.org.uk>
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] [PATCH] rt2500usb - Don't claim 050d:705{0/a}
Date: Thu, 25 Oct 2007 20:35:20 +0100
User-Agent: KMail/1.9.5
Cc: Parag Warudkar <kernel-stuff@comcast.net>, linux-kernel@vger.kernel.org
References: <alpine.DEB.0.99.0710241909250.18618@parag-desktop>
In-Reply-To: <alpine.DEB.0.99.0710241909250.18618@parag-desktop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710252035.20546.linux@baker-net.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 October 2007 00:22, Parag Warudkar wrote:
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

Unfortunately Belkin have sold both RT73 and RT2500 devices with
that USB ID. You don't say what distro you are runing or what version
of RT2x00 it ships with but last time I checked with the git version of
rt2x00 it tried to load both drivers but the rt2500 driver noticed it was the 
wrong hardware and shut down.

My Belkin stick is busy right now but I'll test that still works later.

> There is another ID 050d:7050 which is also claimed to be handled by both
> rt3500usb and rt73usb. Assuming rt73usb can drive this as well (I have no
> way to be sure as I don't have device with this ID) the following patch
> makes sure only rt73usb claims the 2 devices.
>

There are a few such devices but they are all cases where there are reliable 
reports of manufacturers shipping both device types with one USB ID. There 
are some cases where the alternate chipset with the same USB ID isn't even a 
ralink device but there isn't much we can do about those.
