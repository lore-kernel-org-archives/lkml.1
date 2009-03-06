Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbZCFC44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbZCFC44 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 21:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbZCFC4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 21:56:46 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:26398 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbZCFC4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 21:56:45 -0500
Message-ID: <49B09126.1040204@oracle.com>
Date: Thu, 05 Mar 2009 18:57:42 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
       Mike Murphy <mamurph@cs.clemson.edu>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH -mmotm] xpad: fix build error and warnings
References: <200903060051.n260p4gp022115@imap1.linux-foundation.org>
In-Reply-To: <200903060051.n260p4gp022115@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.49B090C5.0023:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add a dummy xpad_send_led_command() for the case of
CONFIG_JOYSTICK_XPAD_LEDS=n.  Fixes this build error:

ERROR: "xpad_send_led_command" [drivers/input/joystick/xpad.ko] undefined!

Remove 2 duplicate function prototypes in xpad.h.

Fix these xpad.h warnings:
drivers/input/joystick/xpad.h:231: warning: 'enum led_brightness' declared inside parameter list
drivers/input/joystick/xpad.h:231: warning: its scope is only this definition or declaration, which is probably not what you want
drivers/input/joystick/xpad.h:231: warning: 'struct led_classdev' declared inside parameter list
drivers/input/joystick/xpad.h:231: warning: 'xpad_led_set' declared 'static' but never defined

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Mike Murphy <mamurph@cs.clemson.edu>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/joystick/xpad.c |    3 ++-
 drivers/input/joystick/xpad.h |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

--- mmotm-2009-0305-1632.orig/drivers/input/joystick/xpad.h
+++ mmotm-2009-0305-1632/drivers/input/joystick/xpad.h
@@ -224,13 +224,13 @@ static void xpad_irq_in(struct urb *urb)
 static void xpad_irq_out(struct urb *urb);
 static int xpad_init_output(struct usb_interface *intf, struct usb_xpad *xpad);
 static void xpad_stop_output(struct usb_xpad *xpad);
-static void xpad_stop_output(struct usb_xpad *xpad);
 static int xpad_play_effect(struct input_dev *dev, void *data,
 			    struct ff_effect *effect);
 static int xpad_init_ff(struct usb_xpad *xpad);
-static void xpad_send_led_command(struct usb_xpad *xpad, int command);
+#ifdef CONFIG_JOYSTICK_XPAD_LEDS
 static void xpad_led_set(struct led_classdev *led_cdev,
 	enum led_brightness value);
+#endif
 static int xpad_led_probe(struct usb_xpad *xpad);
 static void xpad_led_disconnect(struct usb_xpad *xpad);
 static int xpad_open(struct input_dev *dev);
--- mmotm-2009-0305-1632.orig/drivers/input/joystick/xpad.c
+++ mmotm-2009-0305-1632/drivers/input/joystick/xpad.c
@@ -1076,9 +1076,10 @@ static void xpad_led_disconnect(struct u
 	}
 }
 #else
-/* dummies for xpad_probe and xpad_disconnect */
+/* dummies for xpad_probe, xpad_disconnect, & xpad_send_led_command */
 static int xpad_led_probe(struct usb_xpad *xpad) { return 0; }
 static void xpad_led_disconnect(struct usb_xpad *xpad) { }
+static void xpad_send_led_command(struct usb_xpad *xpad, int command) { }
 #endif
 
 /* end LED section */

