Return-Path: <linux-kernel-owner+w=401wt.eu-S1754667AbXJIJh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbXJIJh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 05:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbXJIJhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 05:37:16 -0400
Received: from smtp27.orange.fr ([80.12.242.94]:38869 "EHLO smtp27.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbXJIJhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 05:37:15 -0400
X-ME-UUID: 20071009093713299.492651C00081@mwinf2729.orange.fr
Subject: Re: Patch for WindowsMobile5 on Linux Kernel
From: Xavier Bestel <xavier.bestel@free.fr>
To: Bernd Petrovitsch <bernd@firmix.at>
Cc: "Grosjo.net - jom" <jom@grosjo.net>, linux-kernel@vger.kernel.org
In-Reply-To: <1191922365.5559.1.camel@tara.firmix.at>
References: <470B47D9.30406@grosjo.net>
	 <1191922365.5559.1.camel@tara.firmix.at>
Content-Type: text/plain
Date: Tue, 09 Oct 2007 11:37:09 +0200
Message-Id: <1191922629.10146.28.camel@frg-rhel40-em64t-04>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-09 at 11:32 +0200, Bernd Petrovitsch wrote:
> On Die, 2007-10-09 at 12:20 +0300, Grosjo.net - jom wrote:
> [...]
> > Would it be possible to include the patches (available on www.synce.org)
> > for WindowsMobile5, as most mobile phones are under Window$, and it is
> > very convenient to connect it to the laptop under Linux
> 
> do {
>    Test them
>    review them
>    sent them as patches hereover
>    handle feedback
> until(accepted)

FWIW, the patch in question is a one-liner:

--- linux-2.6.22-rc3-orig/drivers/net/usb/rndis_host.c	2007-05-25 22:55:14.000000000 -0400
+++ linux-2.6.22-rc3/drivers/net/usb/rndis_host.c	2007-05-27 17:06:16.000000000 -0400
@@ -499,8 +499,7 @@
 	net->hard_header_len += sizeof (struct rndis_data_hdr);
 	dev->hard_mtu = net->mtu + net->hard_header_len;
 
-	dev->rx_urb_size = dev->hard_mtu + (dev->maxpacket + 1);
-	dev->rx_urb_size &= ~(dev->maxpacket - 1);
+	dev->rx_urb_size = (dev->udev->speed == USB_SPEED_FULL) ? 16384 : 8192;
 	u.init->max_transfer_size = cpu_to_le32(dev->rx_urb_size);
 
 	net->change_mtu = NULL;


	Xav


