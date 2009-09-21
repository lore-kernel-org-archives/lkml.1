Return-Path: <linux-kernel-owner+w=401wt.eu-S1753740AbZIUUDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbZIUUDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 16:03:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753681AbZIUUDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 16:03:10 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:36832 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbZIUUDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 16:03:09 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Henk Martijn <h.h.martijn@gmail.com>, linux-input@vger.kernel.org
Subject: Re: 2.6.31-0.1-default-07068-g43c1266 lockdep warning and scheduling while atomic BUG
Date: Mon, 21 Sep 2009 22:04:49 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc9-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <1253560490.2934.42.camel@localhost> <4AB7D9B8.6000501@gmail.com>
In-Reply-To: <4AB7D9B8.6000501@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909212204.50047.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 21. September 2009 21:53:28 schrieb Henk Martijn:
> This is a i7 based DELL and current git throws the following warning and
> bug at me during boot:

Please try this patch

	Regards
		Oliver

--

commit ca5c4a1397d1a1c0d1074f4d8922630fdd732780
Author: Oliver Neukum <oliver@neukum.org>
Date:   Mon Sep 21 22:02:01 2009 +0200

    hid:usbhid: fix wrong use of GFP_KERNEL
    
    hid_input_report() must be told it is called in interrupt context

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 1b0e07a..ab2869d 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -455,7 +455,7 @@ static void hid_ctrl(struct urb *urb)
 		if (usbhid->ctrl[usbhid->ctrltail].dir == USB_DIR_IN)
 			hid_input_report(urb->context,
 				usbhid->ctrl[usbhid->ctrltail].report->type,
-				urb->transfer_buffer, urb->actual_length, 0);
+				urb->transfer_buffer, urb->actual_length, 1);
 		break;
 	case -ESHUTDOWN:	/* unplug */
 		unplug = 1;

