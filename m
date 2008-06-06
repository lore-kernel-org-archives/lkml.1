Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbYFFLjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbYFFLjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 07:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbYFFLjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 07:39:11 -0400
Received: from n1.cetrtapot.si ([89.212.80.162]:50153 "EHLO n1.cetrtapot.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287AbYFFLjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 07:39:10 -0400
Message-ID: <4849218D.7080306@cetrtapot.si>
Date: Fri, 06 Jun 2008 13:37:49 +0200
From: =?UTF-8?B?SGlua28gS2/EjWV2YXI=?= <hinko.kocevar@cetrtapot.si>
User-Agent: Thunderbird 2.0.0.14 (X11/20080508)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: dev-etrax@axis.com
Subject: Re: [PATCH 2.6.26-rc5 1/2] cris: compile fixes for 2.6.26-rc5
References: <4849213A.4080001@cetrtapot.si>
In-Reply-To: <4849213A.4080001@cetrtapot.si>
Content-Type: multipart/mixed;
 boundary="------------080505070008020909080401"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080505070008020909080401
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Add dummy ops for serial debug port.

Signed-off-by: Hinko Kocevar <hinko.kocevar@cetrtapot.si>

---


--------------080505070008020909080401
Content-Type: text/x-patch;
 name="001-cris-debugport-add-dummy-ops.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="001-cris-debugport-add-dummy-ops.patch"

diff --git a/arch/cris/arch-v10/kernel/debugport.c b/arch/cris/arch-v10/kernel/debugport.c
index 04d5eee..429a281 100644
--- a/arch/cris/arch-v10/kernel/debugport.c
+++ b/arch/cris/arch-v10/kernel/debugport.c
@@ -432,6 +432,13 @@ dummy_write_room(struct tty_struct *tty)
 	return 8192;
 }
 
+static struct tty_operations dummy_ops = {
+	.open = &dummy_open,
+	.close = &dummy_close,
+	.write = &dummy_write,
+	.write_room = &dummy_write_room,
+};
+
 void __init
 init_dummy_console(void)
 {
@@ -448,10 +455,7 @@ init_dummy_console(void)
 		B115200 | CS8 | CREAD | HUPCL | CLOCAL; /* is normally B9600 default... */
 	dummy_driver.flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
 
-	dummy_driver.open = dummy_open;
-	dummy_driver.close = dummy_close;
-	dummy_driver.write = dummy_write;
-	dummy_driver.write_room = dummy_write_room;
+	dummy_driver.ops = &dummy_ops;
 	if (tty_register_driver(&dummy_driver))
 		panic("Couldn't register dummy serial driver\n");
 }

--------------080505070008020909080401--
