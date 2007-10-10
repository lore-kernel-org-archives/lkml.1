Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbXJJGho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbXJJGho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 02:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbXJJGhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 02:37:37 -0400
Received: from zap.org.AU ([129.94.172.224]:59258 "EHLO mail.zap.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbXJJGhg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 02:37:36 -0400
X-Greylist: delayed 2254 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Oct 2007 02:37:35 EDT
Date: Wed, 10 Oct 2007 15:59:58 +1000
From: John Zaitseff <J.Zaitseff@zap.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: Key codes for Microsoft Natural Ergonomic 4000 USB keyboard
Message-ID: <20071010055958.GA25938@zap.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Zaitseff <J.Zaitseff@zap.org.au>

The following patch to Linux kernel 2.6.23 enables most of the
extra keys found on the Microsoft Natural Ergonomic 4000 USB
keyboard.  I had to add one keycode to include/linux/input.h; feel
free to reallocate the ID assigned to it (KEY_SPELL).

Main changes:

* Enabled the use of the extra "(" and ")" in the top right-hand
  part of the keyboard, above the keypad

* Enable the My Favorites key in the centre of the keyboard (mapped
  to KEY_FAVORITES)

* Map the F1-F12 keys to appropriate keys when the F Lock is off
  (this is quite easy as the keyboard already generates different
  USB key events)

Changes still to be made:

* Map the five buttons above My Favorites to KEY_FN_F1 to KEY_FN_F5

I am not sure how to do this last change correctly: the keyboard
returns a usage->hid of (HID_UP_MSVENDOR | 0xff05) whenever any of
the five keys are pressed or let go (as well as at certain other
times, when the value is 0):

  value = 0x00  --->  none of the five keys are pressed
  value = 0x01  --->  key 1 is pressed
  value = 0x02  --->  key 2 is pressed
  value = 0x04  --->  key 3 is pressed
  value = 0x08  --->  key 4 is pressed
  value = 0x10  --->  key 5 is pressed

Note that although this looks like a bitfield, multiple keys CANNOT
in effect be pressed simultaneously: only one of these six values
is ever returned (as tested).

In any case, this will be for a second patch, once the one in this
e-mail is applied.

Please apply if at all possible!  Please CC me on any discussion,
as I am not subscribed to the mailing lists.

Signed-off-by: John Zaitseff <J.Zaitseff@zap.org.au>
---

 drivers/hid/hid-debug.c     |    4 +++-
 drivers/hid/hid-input.c     |    4 +++-
 drivers/hid/usbhid/usbkbd.c |    2 +-
 include/linux/input.h       |    1 +
 4 files changed, 8 insertions(+), 3 deletions(-)


diff -ruNp linux-2.6.23.orig/drivers/hid/hid-debug.c linux-2.6.23/drivers/hid/hid-debug.c
--- linux-2.6.23.orig/drivers/hid/hid-debug.c	2007-10-10 06:31:38.000000000 +1000
+++ linux-2.6.23/drivers/hid/hid-debug.c	2007-10-10 15:32:22.000000000 +1000
@@ -692,7 +692,9 @@ static char *keys[KEY_MAX + 1] = {
 	[KEY_SLOW] = "Slow",			[KEY_SHUFFLE] = "Shuffle",
 	[KEY_BREAK] = "Break",			[KEY_PREVIOUS] = "Previous",
 	[KEY_DIGITS] = "Digits",		[KEY_TEEN] = "TEEN",
-	[KEY_TWEN] = "TWEN",			[KEY_DEL_EOL] = "DeleteEOL",
+	[KEY_TWEN] = "TWEN",			[KEY_HELP] = "Help",
+	[KEY_ZOOMIN] = "ZoomIn",		[KEY_ZOOMOUT] = "ZoomOut",
+	[KEY_DEL_EOL] = "DeleteEOL",
 	[KEY_DEL_EOS] = "DeleteEOS",		[KEY_INS_LINE] = "InsertLine",
 	[KEY_DEL_LINE] = "DeleteLine",
 	[KEY_SEND] = "Send",			[KEY_REPLY] = "Reply",
diff -ruNp linux-2.6.23.orig/drivers/hid/hid-input.c linux-2.6.23/drivers/hid/hid-input.c
--- linux-2.6.23.orig/drivers/hid/hid-input.c	2007-10-10 06:31:38.000000000 +1000
+++ linux-2.6.23/drivers/hid/hid-input.c	2007-10-10 15:40:58.000000000 +1000
@@ -53,7 +53,7 @@ static const unsigned char hid_keyboard[
 	115,114,unk,unk,unk,121,unk, 89, 93,124, 92, 94, 95,unk,unk,unk,
 	122,123, 90, 91, 85,unk,unk,unk,unk,unk,unk,unk,unk,unk,unk,unk,
 	unk,unk,unk,unk,unk,unk,unk,unk,unk,unk,unk,unk,unk,unk,unk,unk,
-	unk,unk,unk,unk,unk,unk,unk,unk,unk,unk,unk,unk,unk,unk,unk,unk,
+	unk,unk,unk,unk,unk,unk,179,180,unk,unk,unk,unk,unk,unk,unk,unk,
 	unk,unk,unk,unk,unk,unk,unk,unk,unk,unk,unk,unk,unk,unk,unk,unk,
 	unk,unk,unk,unk,unk,unk,unk,unk,unk,unk,unk,unk,unk,unk,unk,unk,
 	 29, 42, 56,125, 97, 54,100,126,164,166,165,163,161,115,114,113,
@@ -595,6 +595,7 @@ static void hidinput_configure_usage(str
 				case 0x0f6: map_key_clear(KEY_NEXT);		break;
 				case 0x0fa: map_key_clear(KEY_BACK);		break;
 
+				case 0x182: map_key_clear(KEY_FAVORITES);	break;
 				case 0x183: map_key_clear(KEY_CONFIG);		break;
 				case 0x184: map_key_clear(KEY_WORDPROCESSOR);	break;
 				case 0x185: map_key_clear(KEY_EDITOR);		break;
@@ -614,6 +615,7 @@ static void hidinput_configure_usage(str
 				case 0x19e: map_key_clear(KEY_COFFEE);		break;
 				case 0x1a6: map_key_clear(KEY_HELP);		break;
 				case 0x1a7: map_key_clear(KEY_DOCUMENTS);	break;
+				case 0x1ab: map_key_clear(KEY_SPELL);		break;
 				case 0x1bc: map_key_clear(KEY_MESSENGER);	break;
 				case 0x1bd: map_key_clear(KEY_INFO);		break;
 				case 0x201: map_key_clear(KEY_NEW);		break;
diff -ruNp linux-2.6.23.orig/drivers/hid/usbhid/usbkbd.c linux-2.6.23/drivers/hid/usbhid/usbkbd.c
--- linux-2.6.23.orig/drivers/hid/usbhid/usbkbd.c	2007-10-10 06:31:38.000000000 +1000
+++ linux-2.6.23/drivers/hid/usbhid/usbkbd.c	2007-10-10 15:42:48.000000000 +1000
@@ -57,7 +57,7 @@ static unsigned char usb_kbd_keycode[256
 	115,114,  0,  0,  0,121,  0, 89, 93,124, 92, 94, 95,  0,  0,  0,
 	122,123, 90, 91, 85,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
 	  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
-	  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
+	  0,  0,  0,  0,  0,  0,179,180,  0,  0,  0,  0,  0,  0,  0,  0,
 	  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
 	  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
 	 29, 42, 56,125, 97, 54,100,126,164,166,165,163,161,115,114,113,
diff -ruNp linux-2.6.23.orig/include/linux/input.h linux-2.6.23/include/linux/input.h
--- linux-2.6.23.orig/include/linux/input.h	2007-10-10 06:31:38.000000000 +1000
+++ linux-2.6.23/include/linux/input.h	2007-10-10 15:20:50.000000000 +1000
@@ -522,6 +522,7 @@ struct input_absinfo {
 #define KEY_ADDRESSBOOK		0x1ad	/* AL Contacts/Address Book */
 #define KEY_MESSENGER		0x1ae	/* AL Instant Messaging */
 #define KEY_DISPLAYTOGGLE	0x1af	/* Turn display (LCD) on and off */
+#define KEY_SPELL		0x1b0
 
 #define KEY_DEL_EOL		0x1c0
 #define KEY_DEL_EOS		0x1c1



-- 
John Zaitseff                    ,--_|\    The ZAP Group
Phone:  +61 2 9643 7737         /      \   Sydney, Australia
E-mail: J.Zaitseff@zap.org.au   \_,--._*   http://www.zap.org.au/
                                      v
