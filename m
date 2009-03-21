Return-Path: <linux-kernel-owner+w=401wt.eu-S1756358AbZCUXFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358AbZCUXFm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 19:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754279AbZCUXFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 19:05:34 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44517 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbZCUXFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 19:05:33 -0400
Date: Sun, 22 Mar 2009 00:08:19 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, eric.piel@tremplin-utc.net
Subject: axes conversion for hp compaq 8710w for HP_ACCEL linux kernel
	module (fwd)
Message-ID: <20090321230819.GF12291@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

It seems like Luca has one  more whitelist entry...
								Pavel


Subject: axes conversion for hp compaq 8710w for HP_ACCEL linux kernel module
From: Luca Cappa <lcappa@gmail.com>


Hello,

I have a laptop HP Compaq 8710W, I compiled into my kernel the
LIS3LV02DL and HP_ACCEL module drivers. While loading it cannot
recognize the laptop
model, so i am sending the necessary information to update the
database of Axes Orientations.

>When the laptop is horizontal the position reported is about 0 for X and Y
>and a positive value for Z
Yes, it is about 0,0,1000, the actual reading says: (-17,-26,1018);

> If the left side is elevated, X increases (becomes positive)
Yes, X goes toward to positive 1000.

>If the front side (where the touchpad is) is elevated, Y decreases (becomes negative)
No, Y goes toward to positive 1000.

>If the laptop is put upside-down, Z becomes negative
Yes, the laptop on a table Z gives 1000, and if upsidedown the Z reads
-1000.

So in few words the Y axis is inverted,  I paste here below the very
simple patch to configure properly the axis conversion. The patch is
against the file hp_accel.c of 2.6.29-rc8, i.e. the one shown here:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/hwmon/hp_accel.c;h=29c83b5b96974bb88cbeb67d896ba46ee71469f2;hb=HEAD

Greetings,
Luca


--- /home/luca/Desktop/hp_accel.c	2009-03-21 19:28:54.000000000 +0100
+++ hp_accel.c	2009-03-21 19:31:05.000000000 +010
@@ -201,6 +201,7 @@
 			PRODUCT_NAME, "HP Pavilion dv5",
 			BOARD_NAME, "3600",
 			y_inverted),
+    AXIS_DMI_MATCH("HP8710", "HP Compaq 8710", y_inverted),
 	{ NULL, }
 /* Laptop models witho

----- End forwarded message -----

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
