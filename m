Return-Path: <linux-kernel-owner+w=401wt.eu-S1751533AbXCPBPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbXCPBPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 21:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbXCPBPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 21:15:34 -0400
Received: from gundega.hpl.hp.com ([192.6.19.190]:52019 "EHLO
	gundega.hpl.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbXCPBPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 21:15:32 -0400
Date: Thu, 15 Mar 2007 18:12:57 -0700
To: Luc Saillard <luc@saillard.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-dvb@linuxtv.org
Subject: [PATCH 2.6.20] pwc : Cisco VT Camera support
Message-ID: <20070316011257.GB13009@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: jt@hpl.hp.com
User-Agent: Mutt/1.5.9i
From: Jean Tourrilhes <jt@hpl.hp.com>
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: jt@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi,

	I already sent this e-mail to Luc and on the pwc mailing list,
and got no answer. I'm trying again with the hope that this patch
would go in the kernel...


        I have a Cisco VT Camera, and it was just collecting dust. I
decided to try connecting it to my Linux box at home.

        Just a disgression about the product. The Cisco VT Camera is a
webcam Cisco sold to work with their IP phone hardware and
software. It's mostly useless on Windows, as it interfaces only to
Cisco software. You can find some for cheap on eBay...
        Physically, it's just a Logitech Pro 4000. The only difference
with the Pro 4000 is the Cisco logo and that it's grey like the Pro
3000.
        I believe Cisco is now selling the Cisco VT Camera II, which
look to be something else...

        So, assuming that it was a Pro 4000 inside, I created the
little patch attached.
        I'm new to webcam under Linux, but I managed to get an image
from it using xawtv, and the image looked all right, so I consider
that a success. The imaged seemed a bit small and I could not get the
microphone driver loaded, but I assume it's my lack of experience.
        Note that I did not try any other type_id, but this one works
great.

        Have fun...

        Jean

---------------------------------------------------------------

diff -u -p linux/drivers/media/video/pwc/pwc-if.c~ linux/drivers/media/video/pwc/pwc-if.c
--- linux/drivers/media/video/pwc/pwc-if.c~	2007-02-23 22:08:40.000000000 -0800
+++ linux/drivers/media/video/pwc/pwc-if.c	2007-03-04 22:42:43.000000000 -0800
@@ -1547,6 +1547,10 @@ static int usb_pwc_probe(struct usb_inte
 			features |= FEATURE_MOTOR_PANTILT;
 			break;
 		case 0x08b6:
+			PWC_INFO("Logitech/Cisco VT Camera webcam detected.\n");
+			name = "Cisco VT Camera";
+			type_id = 740; /* CCD sensor */
+			break;
 		case 0x08b7:
 		case 0x08b8:
 			PWC_INFO("Logitech QuickCam detected (reserved ID).\n");
