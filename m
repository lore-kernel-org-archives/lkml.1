Return-Path: <linux-kernel-owner+w=401wt.eu-S1756510AbYFFMOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbYFFMOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 08:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820AbYFFMNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 08:13:52 -0400
Received: from n1.cetrtapot.si ([89.212.80.162]:50488 "EHLO n1.cetrtapot.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758AbYFFMNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 08:13:51 -0400
Message-ID: <484929AA.5030606@cetrtapot.si>
Date: Fri, 06 Jun 2008 14:12:26 +0200
From: =?ISO-8859-1?Q?Hinko_Koc=28evar?= <hinko.kocevar@cetrtapot.si>
User-Agent: Thunderbird 2.0.0.14 (X11/20080508)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, dev-etrax@axis.com
Subject: Re: [PATCH 2.6.26-rc5 1/2] cris: compile fixes for 2.6.26-rc5
References: <4849213A.4080001@cetrtapot.si>	<4849218D.7080306@cetrtapot.si> <20080606124149.2d87f980@core>
In-Reply-To: <20080606124149.2d87f980@core>
Content-Type: multipart/mixed;
 boundary="------------020102020907040007000104"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020102020907040007000104
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Stab 2

Add dummy ops for serial debug port.
Add setting of c_ispeed/c_ospeed as suggested by Alan Cox.

Signed-off-by: Hinko Kocevar <hinko.kocevar@cetrtapot.si>

---



--------------020102020907040007000104
Content-Type: text/x-patch;
 name="001-cris-debugport-add-dummy-ops.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="001-cris-debugport-add-dummy-ops.patch"

diff --git a/arch/cris/arch-v10/kernel/debugport.c b/arch/cris/arch-v10/kernel/debugport.c
index 04d5eee..36eee3d 100644
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
@@ -447,11 +454,10 @@ init_dummy_console(void)
 	dummy_driver.init_termios.c_cflag =
 		B115200 | CS8 | CREAD | HUPCL | CLOCAL; /* is normally B9600 default... */
 	dummy_driver.flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
+	dummy_driver.init_termios.c_ispeed = 115200;
+	dummy_driver.init_termios.c_ospeed = 115200;
 
-	dummy_driver.open = dummy_open;
-	dummy_driver.close = dummy_close;
-	dummy_driver.write = dummy_write;
-	dummy_driver.write_room = dummy_write_room;
+	dummy_driver.ops = &dummy_ops;
 	if (tty_register_driver(&dummy_driver))
 		panic("Couldn't register dummy serial driver\n");
 }

--------------020102020907040007000104--
