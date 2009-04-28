Return-Path: <linux-kernel-owner+w=401wt.eu-S1756770AbZD1NP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbZD1NP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 09:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754657AbZD1NPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 09:15:48 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:36927 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754039AbZD1NPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 09:15:47 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] input: Document the bcm5974 driver (rev2)
Date: Tue, 28 Apr 2009 15:15:41 +0200
Message-Id: <1240924541-20673-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.5.6.3
X-Originating-IP: 83.248.194.102
X-Scan-Result: No virus found in message 1Lyn9x-0000cZ-68.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1Lyn9x-0000cZ-68 be0b6cf4379a50883c9405fe3bef242d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds documentation for the bcm5974 to Documentation/input/.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 Documentation/input/bcm5974.txt |   65 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 65 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/input/bcm5974.txt

diff --git a/Documentation/input/bcm5974.txt b/Documentation/input/bcm5974.txt
new file mode 100644
index 0000000..5e22dcf
--- /dev/null
+++ b/Documentation/input/bcm5974.txt
@@ -0,0 +1,65 @@
+BCM5974 Driver (bcm5974)
+------------------------
+	Copyright (C) 2008-2009	Henrik Rydberg <rydberg@euromail.se>
+
+The USB initialization and package decoding was made by Scott Shawcroft as
+part of the touchd user-space driver project:
+	Copyright (C) 2008	Scott Shawcroft (scott.shawcroft@gmail.com)
+
+The BCM5974 driver is based on the appletouch driver:
+	Copyright (C) 2001-2004	Greg Kroah-Hartman (greg@kroah.com)
+	Copyright (C) 2005	Johannes Berg (johannes@sipsolutions.net)
+	Copyright (C) 2005	Stelian Pop (stelian@popies.net)
+	Copyright (C) 2005	Frank Arnold (frank@scirocco-5v-turbo.de)
+	Copyright (C) 2005	Peter Osterlund (petero2@telia.com)
+	Copyright (C) 2005	Michael Hanselmann (linux-kernel@hansmi.ch)
+	Copyright (C) 2006	Nicolas Boichat (nicolas@boichat.ch)
+
+This driver adds support for the multi-touch trackpad on the new Apple
+Macbook Air and Macbook Pro laptops. It replaces the appletouch driver on
+those computers, and integrates well with the synaptics driver of the Xorg
+system.
+
+Known to work on Macbook Air, Macbook Pro Penryn and the new unibody
+Macbook 5 and Macbook Pro 5.
+
+Usage
+-----
+
+The driver loads automatically for the supported usb device ids, and
+becomes available both as an event device (/dev/input/event*) and as a
+mouse via the mousedev driver (/dev/input/mice).
+
+USB Race
+--------
+
+The Apple multi-touch trackpads report both mouse and keyboard events via
+different interfaces of the same usb device. This creates a race condition
+with the HID driver, which, if not told otherwise, will find the standard
+HID mouse and keyboard, and claim the whole device. To remedy, the usb
+product id must be listed in the mouse_ignore list of the hid driver.
+
+Debug output
+------------
+
+To ease the development for new hardware version, verbose packet output can
+be switched on with the debug kernel module parameter. The range [1-9]
+yields different levels of verbosity. Example (as root):
+
+echo -n 9 > /sys/module/bcm5974/parameters/debug
+
+tail -f /var/log/debug
+
+echo -n 0 > /sys/module/bcm5974/parameters/debug
+
+Trivia
+------
+
+The driver was developed at the ubuntu forums in June 2008 [1], and now has
+a more permanent home at bitmath.org [2].
+
+Links
+-----
+
+[1] http://ubuntuforums.org/showthread.php?t=840040
+[2] http://http://bitmath.org/code/
-- 
1.5.6.3

