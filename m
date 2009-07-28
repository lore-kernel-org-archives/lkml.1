Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbZG2AAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbZG2AAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 20:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932206AbZG2AAC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 20:00:02 -0400
Received: from kroah.org ([198.145.64.141]:35730 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017AbZG1Xtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:49:53 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:54 2009
Message-Id: <20090728234154.699869310@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:40:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hao Song <baritono.tux@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [patch 23/71] ALSA: hda - Add quirk for Gateway T6834c laptop
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=alsa-hda-add-quirk-for-gateway-t6834c-laptop.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hao Song <baritono.tux@gmail.com>

commit 42b95f0c6b524b5a670dd17533a3522db368f600 upstream.

Gateway T6834c laptops need EAPD always on while the default behavior
for the STAC9205 reference board is to turn it off upon every HP plug.
By using the special "eapd" model, which is first introduced for Gateway
T1616 laptops for this same reason, this peculiarity can be properly
handled.

Signed-off-by: Hao Song <baritono.tux@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_sigmatel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -2325,6 +2325,7 @@ static struct snd_pci_quirk stac9205_cfg
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x0228,
 		      "Dell Vostro 1500", STAC_9205_DELL_M42),
 	/* Gateway */
+	SND_PCI_QUIRK(0x107b, 0x0560, "Gateway T6834c", STAC_9205_EAPD),
 	SND_PCI_QUIRK(0x107b, 0x0565, "Gateway T1616", STAC_9205_EAPD),
 	{} /* terminator */
 };


