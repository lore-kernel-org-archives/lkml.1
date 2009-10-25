Return-Path: <linux-kernel-owner+w=401wt.eu-S1753937AbZJYRyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbZJYRyE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 13:54:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753861AbZJYRyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 13:54:03 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:46624 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbZJYRx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 13:53:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=vBQBMOA5regUi9XzlErtxX9oChKldF4lyyJqQUjNkLUnBID+G+NFg7Or/fHeVNe7ke
         W4/yr0+N3Dep1tvi9xRM2A2VoWZ2R1chW5/zeH9pLAJ6LyTMqcKHcC54QANMZcsD0UzT
         oYJFSKb8V2NJYfxkyp/NLOFDbPyYIoyeYeq5E=
Message-Id: <20091025175330.419919549@gmail.com>
References: <20091025175057.270011110@gmail.com>
User-Agent: quilt/0.46-1
Date: Sun, 25 Oct 2009 18:51:04 +0100
From: bart.hartgers@gmail.com
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bart Hartgers <bart.hartgers@gmail.com>
Subject: [PATCH 7/7] ark3116: (3rd try) Cleanup of now unneeded functions
Content-Disposition: inline; filename=0035_ark3116_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bart Hartgers <bart.hartgers@gmail.com>
---
Index: linux-2.6.32-rc4/drivers/usb/serial/ark3116.c
===================================================================
--- linux-2.6.32-rc4.orig/drivers/usb/serial/ark3116.c	2009-10-18 16:20:23.000000000 +0200
+++ linux-2.6.32-rc4/drivers/usb/serial/ark3116.c	2009-10-18 16:20:26.000000000 +0200
@@ -112,45 +112,6 @@ static int ark3116_read_reg(struct usb_s
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
 static inline void ark3116_atomic_set_clear(unsigned set,
 					    unsigned clear, atomic_t *at)
 {

-- 
