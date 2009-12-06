Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbZLGAgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbZLGAgT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758291AbZLGAgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:36:11 -0500
Received: from kroah.org ([198.145.64.141]:34191 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758260AbZLGAMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:12:33 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:42 2009
Message-Id: <20091207000642.408714542@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 15:59:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Julian Anastasov <ja@ssi.bg>, Takashi Iwai <tiwai@suse.de>
Subject: [012/119] ALSA: usb-audio: fix combine_word problem
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=alsa-usb-audio-fix-combine_word-problem.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Julian Anastasov <ja@ssi.bg>

commit f495088210c8b9e20791d995a8210170c68d2deb upstream.

Fix combine_word problem where first octet is not
read properly. The only affected place seems to be the
INPUT_TERMINAL type. Before now, sound controls can be created
with the output terminal's name which is a fallback mechanism
used only for unknown input terminal types. For example,
Line can wrongly appear as Speaker. After the change it
should appear as Line.

	The side effect of this change can be that users
can expect the wrong control name in their scripts or
programs while now we return the correct one.

	Probably, these defines should use get_unaligned_le16 and
friends.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/usb/usbaudio.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -210,7 +210,7 @@ struct snd_usb_midi_endpoint_info {
 /*
  */
 
-#define combine_word(s)    ((*s) | ((unsigned int)(s)[1] << 8))
+#define combine_word(s)    ((*(s)) | ((unsigned int)(s)[1] << 8))
 #define combine_triple(s)  (combine_word(s) | ((unsigned int)(s)[2] << 16))
 #define combine_quad(s)    (combine_triple(s) | ((unsigned int)(s)[3] << 24))
 


