Return-Path: <linux-kernel-owner+w=401wt.eu-S1757715AbZKJS77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715AbZKJS77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 13:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757660AbZKJS77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 13:59:59 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:4371 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757649AbZKJS76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 13:59:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=bYrcv6A6uyrmtq+FI16mhTonJW5nsKCUDQcRczbA631WTrjGIvO5R2c8DG3x1NY8iJ
         zOyP7y83y+JxYuREqQzMVkYjJxBf2W172ZaeywO1OqGVoM4ocCx7G5iioO006XTBzFfp
         3n6w/IQsD7zr/ZuV3V33r05HYgR9bk06RZD+Q=
Message-ID: <4AF9BAFB.3090403@gmail.com>
Date: Tue, 10 Nov 2009 20:11:55 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       alsa-devel@alsa-project.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ALSA: possible read past array alc88[02]_parse_auto_config()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The test of index `i' is after the read - too late - and
unsafe: if snd_hda_get_connections() fails in the last
iteration a read beyond the array is possible.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 sound/pci/hda/patch_realtek.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index ff20048..fd094f5 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4684,9 +4684,9 @@ static int alc880_parse_auto_config(struct hda_codec *codec)
 			spec->multiout.dig_out_nid = dig_nid;
 		else {
 			spec->multiout.slave_dig_outs = spec->slave_dig_outs;
-			spec->slave_dig_outs[i - 1] = dig_nid;
-			if (i == ARRAY_SIZE(spec->slave_dig_outs) - 1)
+			if (i >= ARRAY_SIZE(spec->slave_dig_outs) - 1)
 				break;
+			spec->slave_dig_outs[i - 1] = dig_nid;
 		}
 	}
 	if (spec->autocfg.dig_in_pin)
@@ -9813,9 +9813,9 @@ static int alc882_parse_auto_config(struct hda_codec *codec)
 			spec->multiout.dig_out_nid = dig_nid;
 		else {
 			spec->multiout.slave_dig_outs = spec->slave_dig_outs;
-			spec->slave_dig_outs[i - 1] = dig_nid;
-			if (i == ARRAY_SIZE(spec->slave_dig_outs) - 1)
+			if (i >= ARRAY_SIZE(spec->slave_dig_outs) - 1)
 				break;
+			spec->slave_dig_outs[i - 1] = dig_nid;
 		}
 	}
 	if (spec->autocfg.dig_in_pin)
