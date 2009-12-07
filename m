Return-Path: <linux-kernel-owner+w=401wt.eu-S1758650AbZLGAPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650AbZLGAPa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758654AbZLGAOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:14:30 -0500
Received: from kroah.org ([198.145.64.141]:34836 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934401AbZLGAOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:14:12 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:07:01 2009
Message-Id: <20091207000701.205637134@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:01:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: [118/119] Input: keyboard - fix braille keyboard keysym generation
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=input-keyboard-fix-braille-keyboard-keysym-generation.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Samuel Thibault <samuel.thibault@ens-lyon.org>

commit 46a965462a1c568a7cd7dc338de4a0afa5ce61c5 upstream.

Keysyms stored in key_map[] are not simply K() values, but U(K()) values,
as can be seen in the KDSKBENT ioctl handler.  The kernel-generated
braille keysyms thus need a U() call too.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/keyboard.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/keyboard.c
+++ b/drivers/char/keyboard.c
@@ -1249,7 +1249,7 @@ static void kbd_keycode(unsigned int key
 
 	if (keycode >= NR_KEYS)
 		if (keycode >= KEY_BRL_DOT1 && keycode <= KEY_BRL_DOT8)
-			keysym = K(KT_BRL, keycode - KEY_BRL_DOT1 + 1);
+			keysym = U(K(KT_BRL, keycode - KEY_BRL_DOT1 + 1));
 		else
 			return;
 	else


