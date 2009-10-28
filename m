Return-Path: <linux-kernel-owner+w=401wt.eu-S1752972AbZJ1Jvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbZJ1Jvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 05:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbZJ1Jvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 05:51:32 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:43455 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbZJ1JvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 05:51:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=k5mH+KzwQiZA1Gj2wn+VfMz2R+znlG7iO5+hCTU3inZdOXOQAotaab1C9CVc7KaSoo
         bRElOC5qDJ6fWpS2NfJ3D2vKaKQB5Ol1KS77jEu8ALQcknHTudz9fFU+mnaCuWlnBCfS
         StbUCm2/9E28ryLXrK1QwfWDqFcdCwNuWAW6U=
Message-Id: <20091028095112.823213217@gmail.com>
References: <20091028094324.010816897@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 28 Oct 2009 10:43:30 +0100
From: bart.hartgers@gmail.com
To: Greg Kroah-Hartman <gregkh@suse.de>, Mike McCormack <mikem@ring3k.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bart Hartgers <bart.hartgers@gmail.com>
Subject: [PATCH 6/6] ark3116: (v2) Cleanup of now unneeded functions
Content-Disposition: inline; filename=0035_ark3116_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bart Hartgers <bart.hartgers@gmail.com>
---
Index: linux-2.6.32-rc4/drivers/usb/serial/ark3116.c
===================================================================
--- linux-2.6.32-rc4.orig/drivers/usb/serial/ark3116.c	2009-10-28 10:19:47.000000000 +0100
+++ linux-2.6.32-rc4/drivers/usb/serial/ark3116.c	2009-10-28 10:19:48.000000000 +0100
@@ -113,45 +113,6 @@ static int ark3116_read_reg(struct usb_s
 		return buf[0];
 }
 
-static inline void ARK3116_SND(struct usb_serial *serial, int seq,
-			       __u8 request, __u8 requesttype,
-			       __u16 value, __u16 index)
-{
-	int result;
-	result = usb_control_msg(serial->dev,
-				 usb_sndctrlpipe(serial->dev, 0),
-				 request, requesttype, value, index,
-				 NULL, 0x00, 1000);
-	dbg("%03d > ok", seq);
-}
-
-static inline void ARK3116_RCV(struct usb_serial *serial, int seq,
-			       __u8 request, __u8 requesttype,
-			       __u16 value, __u16 index, __u8 expected,
-			       char *buf)
-{
-	int result;
-	result = usb_control_msg(serial->dev,
-				 usb_rcvctrlpipe(serial->dev, 0),
-				 request, requesttype, value, index,
-				 buf, 0x0000001, 1000);
-	if (result)
-		dbg("%03d < %d bytes [0x%02X]", seq, result,
-		    ((unsigned char *)buf)[0]);
-	else
-		dbg("%03d < 0 bytes", seq);
-}
-
-static inline void ARK3116_RCV_QUIET(struct usb_serial *serial,
-				     __u8 request, __u8 requesttype,
-				     __u16 value, __u16 index, char *buf)
-{
-	usb_control_msg(serial->dev,
-			usb_rcvctrlpipe(serial->dev, 0),
-			request, requesttype, value, index,
-			buf, 0x0000001, 1000);
-}
-
 static inline int calc_divisor(int bps)
 {
 	/* Original ark3116 made some exceptions in rounding here

-- 
