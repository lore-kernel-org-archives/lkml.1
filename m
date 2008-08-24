Return-Path: <linux-kernel-owner+w=401wt.eu-S1756664AbYHXVa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbYHXVa0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 17:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbYHXVaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 17:30:12 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:31280 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbYHXVaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 17:30:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=c4/eiwZkQnlgBRrr3MFtvcprocx69LgOGEDJTFN6jNokE6Hir79+BFg0zZjCDzvF6f
         w1QLY+ITyyGLs7dLCWeupu4Nq3xy5n0McGOv8ewuV3aXn8WvtF9U9+rHIyd6MfjfDZWZ
         AVXAJFuub4ei4kewPkFvodYnXKQsis47C8eVs=
Message-ID: <3d8471ca0808241430p2e3fbb85g63f1340512339d31@mail.gmail.com>
Date: Sun, 24 Aug 2008 23:30:08 +0200
From: "Guillaume Chazarain" <guichaz@gmail.com>
To: "Jaroslav Kysela" <perex@perex.cz>
Subject: Re: [ALSA PATCH] alsa-git merge request
Cc: "Travis Place" <wishie@wishie.net>, "Takashi Iwai" <tiwai@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "ALSA development" <alsa-devel@alsa-project.org>
In-Reply-To: <Pine.LNX.4.61.0807141105150.7676@tm8103-a.perex-int.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.61.0807141105150.7676@tm8103-a.perex-int.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2008 at 11:09 AM, Jaroslav Kysela <perex@perex.cz> wrote:
>      ALSA: hda - Added model selection for iMac 24"

This commit introduces a regression from 2.6.26 on my MacBookPro 3,1.
I lose the "Front" mixer entry but this I don't mind.
The actual regression is that when I plug headphones, the internal
speakers are not muted anymore so I hear the sound from both outputs
(headphones & internal). Reverting this commit fixes the problem for
me.

Thanks.

commit 3e0e469fa216ec70c93b1593821b759d19ee2e6b
Author: Travis Place <wishie@wishie.net>
Date:   Fri Jun 20 16:51:45 2008 +0200

    ALSA: hda - Added model selection for iMac 24"

    Added the SSID of a known iMac 24" to automatically use
    ALC885_IMAC24 quirk.

    Signed-off-by: Travis Place <wishie@wishie.net>
    Signed-off-by: Takashi Iwai <tiwai@suse.de>
    Signed-off-by: Jaroslav Kysela <perex@perex.cz>

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 61f8c13..d96a876 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6192,6 +6192,7 @@ static struct snd_pci_quirk alc882_cfg_tbl[] = {
        SND_PCI_QUIRK(0x1043, 0x817f, "Asus P5LD2", ALC882_6ST_DIG),
        SND_PCI_QUIRK(0x1043, 0x81d8, "Asus P5WD", ALC882_6ST_DIG),
        SND_PCI_QUIRK(0x105b, 0x6668, "Foxconn", ALC882_6ST_DIG),
+       SND_PCI_QUIRK(0x106b, 0x00a0, "Apple iMac 24''", ALC885_IMAC24),
        SND_PCI_QUIRK(0x1458, 0xa002, "Gigabyte P35 DS3R", ALC882_6ST_DIG),
        SND_PCI_QUIRK(0x1462, 0x28fb, "Targa T8", ALC882_TARGA), /*
MSI-1049 T8  */
        SND_PCI_QUIRK(0x1462, 0x6668, "MSI", ALC882_6ST_DIG),



-- 
Guillaume
