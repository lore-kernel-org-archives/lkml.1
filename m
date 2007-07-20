Return-Path: <linux-kernel-owner+w=401wt.eu-S936421AbXGTQr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936421AbXGTQr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 12:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765051AbXGTQoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 12:44:23 -0400
Received: from europa.telenet-ops.be ([195.130.137.75]:40963 "EHLO
	europa.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764752AbXGTQoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 12:44:19 -0400
Message-Id: <20070720164323.625963918@mail.of.borg>
References: <20070720164043.523003359@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Fri, 20 Jul 2007 18:40:44 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@atrey.karlin.mff.cuni.cz, linuxppc-dev@ozlabs.org
Subject: [patch 1/3] m68k/mac: Make mac_hid_mouse_emulate_buttons() declaration visible
Content-Disposition: inline; filename=mac-mac_hid_mouse_emulate_buttons-prototype.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

m68k/mac: Make mac_hid_mouse_emulate_buttons() declaration visible

drivers/char/keyboard.c: In function 'kbd_keycode':
drivers/char/keyboard.c:1142: error: implicit declaration of function 'mac_hid_mouse_emulate_buttons'

The forward declaration of mac_hid_mouse_emulate_buttons() is not visible on
m68k because it's hidden in the middle of a big #ifdef block.

Move it to <linux/hid.h>, correct the type of the second parameter, and
include <linux/hid.h> where needed.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/char/keyboard.c     |    5 +----
 drivers/macintosh/mac_hid.c |    1 +
 include/linux/hid.h         |    3 +++
 3 files changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/char/keyboard.c
+++ b/drivers/char/keyboard.c
@@ -41,6 +41,7 @@
 #include <linux/sysrq.h>
 #include <linux/input.h>
 #include <linux/reboot.h>
+#include <linux/hid.h>
 
 extern void ctrl_alt_del(void);
 
@@ -1022,10 +1023,6 @@ static const unsigned short x86_keycodes
 	308,310,313,314,315,317,318,319,320,357,322,323,324,325,276,330,
 	332,340,365,342,343,344,345,346,356,270,341,368,369,370,371,372 };
 
-#ifdef CONFIG_MAC_EMUMOUSEBTN
-extern int mac_hid_mouse_emulate_buttons(int, int, int);
-#endif /* CONFIG_MAC_EMUMOUSEBTN */
-
 #ifdef CONFIG_SPARC
 static int sparc_l1_a_state = 0;
 extern void sun_do_break(void);
--- a/drivers/macintosh/mac_hid.c
+++ b/drivers/macintosh/mac_hid.c
@@ -13,6 +13,7 @@
 #include <linux/sysctl.h>
 #include <linux/input.h>
 #include <linux/module.h>
+#include <linux/hid.h>
 
 
 static struct input_dev *emumousebtn;
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -522,6 +522,9 @@ int usbhid_quirks_init(char **quirks_par
 void usbhid_quirks_exit(void);
 void usbhid_fixup_report_descriptor(const u16, const u16, char *, unsigned, char **);
 
+/* mac hid */
+extern int mac_hid_mouse_emulate_buttons(int, unsigned int, int);
+
 #ifdef CONFIG_HID_FF
 int hid_ff_init(struct hid_device *hid);
 

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

