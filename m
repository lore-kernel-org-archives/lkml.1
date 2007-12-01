Return-Path: <linux-kernel-owner+w=401wt.eu-S1753093AbXLAKEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbXLAKEz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 05:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbXLAKEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 05:04:40 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:42151 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbXLAKEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 05:04:38 -0500
Date: Sat, 1 Dec 2007 11:04:22 +0100
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: Jaime Velasco Juan <jsagarribay@gmail.com>,
       Oliver Neukum <oliver@neukum.org>,
       Johann Wilhelm <johann.wilhelm@student.tugraz.at>,
       Rui Santos <rsantos@grupopie.com>, linux-usb@vger.kernel.org,
       kristoffer.ericson@gmail.com, drussell@redhat.com,
       linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH] USB: option: Bind to the correct interface of the Huawei E220
Message-ID: <20071201100422.GA14566@gamma.logic.tuwien.ac.at>
References: <20071128161305.b01167b3.zaitcev@redhat.com> <20071129150550.86453nubw8i5xi68@webmail.tugraz.at> <20071129185339.GA10445@singular.local> <200711300023.08999.oliver@neukum.org> <20071130163011.GA4223@singular.local> <20071201080738.GA10031@gamma.logic.tuwien.ac.at> <20071201003455.75b5f0ad.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071201003455.75b5f0ad.zaitcev@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sa, 01 Dez 2007, Pete Zaitcev wrote:
> > is this the only addition that should be needed, ortogether with the
> > changes in option to call the huawei init function?
> 
> The only one.

Ok.

> Your problem is something else. Neither my patch nor Jaime's patch
> address it. Honestly, I'm not even sure how to tackle it. I seem to

Ah, ok.

> recall that I had a usbmon trace from you but I'm unable to find it now.
> Gettin it (again?) probably would be a good place to restart that
> investigation.

I am not sure that I used usbmon ...,I can't recall it, but I know what
the problem is, I need this patch:
--- drivers/usb/storage/initializers.c.orig	2007-11-17 12:29:25.000000000 +0100
+++ drivers/usb/storage/initializers.c	2007-11-17 12:29:37.000000000 +0100
@@ -100,7 +100,7 @@
 	result = usb_stor_control_msg(us, us->send_ctrl_pipe,
 				      USB_REQ_SET_FEATURE,
 				      USB_TYPE_STANDARD | USB_RECIP_DEVICE,
-				      0x01, 0x0, us->iobuf, 0x1, 1000);
+				      0x01, 0x0, us->iobuf, 0, 1000);
 	US_DEBUGP("usb_control_msg performing result is %d\n", result);
 	return (result ? 0 : -1);
 }

With this everything works really smoothly. Even better, now I do get
only 2 (instead of prior 3) /dev/ttyUSB devices (that caused some
problems with umtsmon).

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
POLBATHIC (adj.)
Gifted with ability to manipulate taps using only the feet.
			--- Douglas Adams, The Meaning of Liff
