Return-Path: <linux-kernel-owner+w=401wt.eu-S965799AbXBOKeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965799AbXBOKeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 05:34:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965804AbXBOKeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 05:34:04 -0500
Received: from mail.queued.net ([207.210.101.209]:1465 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965799AbXBOKeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 05:34:01 -0500
Message-ID: <45D43115.6060806@debian.org>
Date: Thu, 15 Feb 2007 05:08:21 -0500
From: Andres Salomon <dilinger@debian.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [patch 1/3] Input: psmouse - create PS/2 protocol options for Kconfig
Content-Type: multipart/mixed;
 boundary="------------020500060202030607000100"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020500060202030607000100
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Initial framework for disabling PS/2 protocol extensions.  The current
protocols can only be disabled if CONFIG_EMBEDDED is selected.  No
source files are changed, merely build stuff.

Signed-off-by: Andres Salomon <dilinger@debian.org>


--------------020500060202030607000100
Content-Type: text/plain;
 name*0="0001-1-3-Input-psmouse-create-PS-2-protocol-options-for-Kconfig.";
 name*1="txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-1-3-Input-psmouse-create-PS-2-protocol-options-for-Kcon";
 filename*1="fig.txt"

diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
index 35d998c..498930d 100644
--- a/drivers/input/mouse/Kconfig
+++ b/drivers/input/mouse/Kconfig
@@ -37,6 +37,56 @@ config MOUSE_PS2
 	  To compile this driver as a module, choose M here: the
 	  module will be called psmouse.
 
+config MOUSE_PS2_ALPS
+	bool "ALPS PS/2 mouse protocol extension" if EMBEDDED
+	default y
+	depends on MOUSE_PS2
+	---help---
+	  Say Y here if you have an ALPS PS/2 touchpad connected to
+	  your system.
+
+	  If unsure, say Y.
+
+config MOUSE_PS2_LOGIPS2PP
+	bool "Logictech PS/2++ mouse protocol extension" if EMBEDDED
+	default y
+	depends on MOUSE_PS2
+	---help---
+	  Say Y here if you have a Logictech PS/2++ mouse connected to
+	  your system.
+
+	  If unsure, say Y.
+
+config MOUSE_PS2_SYNAPTICS
+	bool "Synaptics PS/2 mouse protocol extension" if EMBEDDED
+	default y
+	depends on MOUSE_PS2
+	---help---
+	  Say Y here if you have a Synaptics PS/2 TouchPad connected to
+	  your system.
+
+	  If unsure, say Y.
+
+config MOUSE_PS2_LIFEBOOK
+	bool "Fujitsu Lifebook PS/2 mouse protocol extension" if EMBEDDED
+	default y
+	depends on MOUSE_PS2
+	---help---
+	  Say Y here if you have a Fujitsu B-series Lifebook PS/2
+	  TouchScreen connected to your system.
+
+	  If unsure, say Y.
+
+config MOUSE_PS2_TRACKPOINT
+	bool "IBM Trackpoint PS/2 mouse protocol extension" if EMBEDDED
+	default y
+	depends on MOUSE_PS2
+	---help---
+	  Say Y here if you have an IBM Trackpoint PS/2 mouse connected
+	  to your system.
+
+	  If unsure, say Y.
+
 config MOUSE_SERIAL
 	tristate "Serial mouse"
 	select SERIO
diff --git a/drivers/input/mouse/Makefile b/drivers/input/mouse/Makefile
index 21a1de6..c55aa29 100644
--- a/drivers/input/mouse/Makefile
+++ b/drivers/input/mouse/Makefile
@@ -14,4 +14,9 @@ obj-$(CONFIG_MOUSE_SERIAL)	+= sermouse.o
 obj-$(CONFIG_MOUSE_HIL)		+= hil_ptr.o
 obj-$(CONFIG_MOUSE_VSXXXAA)	+= vsxxxaa.o
 
-psmouse-objs  := psmouse-base.o alps.o logips2pp.o synaptics.o lifebook.o trackpoint.o
+psmouse-objs := psmouse-base.o synaptics.o
+
+psmouse-$(CONFIG_MOUSE_PS2_ALPS)       += alps.o
+psmouse-$(CONFIG_MOUSE_PS2_LOGIPS2PP)  += logips2pp.o
+psmouse-$(CONFIG_MOUSE_PS2_LIFEBOOK)   += lifebook.o
+psmouse-$(CONFIG_MOUSE_PS2_TRACKPOINT) += trackpoint.o
-- 
1.4.4.2


--------------020500060202030607000100--
