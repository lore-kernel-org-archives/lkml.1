Return-Path: <linux-kernel-owner+w=401wt.eu-S1754986AbYKOGfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbYKOGfa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 01:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbYKOGfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 01:35:22 -0500
Received: from nm06omta15.auone-net.jp ([219.125.112.32]:4126 "HELO
	nmomta.auone-net.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752540AbYKOGfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 01:35:21 -0500
X-Greylist: delayed 891 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Nov 2008 01:35:21 EST
Date: Sat, 15 Nov 2008 15:20:14 +0900
From: Kusanagi Kouichi <slash@ma.neweb.ne.jp>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ALSA: hda - Add digital BEEP generator support for Realtek
	codecs.
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Message-ID: <200811150620143407540006MAE0@nm06mta.auone-net.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add digital BEEP generator support for Realtek codecs.

Signed-off-by: Kusanagi Kouichi <slash@ma.neweb.ne.jp>
---
 sound/pci/hda/hda_beep.h      |    2 +-
 sound/pci/hda/patch_realtek.c |   62 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+), 1 deletions(-)

diff --git a/sound/pci/hda/hda_beep.h b/sound/pci/hda/hda_beep.h
index de4036e..b483779 100644
--- a/sound/pci/hda/hda_beep.h
+++ b/sound/pci/hda/hda_beep.h
@@ -38,7 +38,7 @@ struct hda_beep {
 int snd_hda_attach_beep_device(struct hda_codec *codec, int nid);
 void snd_hda_detach_beep_device(struct hda_codec *codec);
 #else
-#define snd_hda_attach_beep_device(...)
+#define snd_hda_attach_beep_device(...)		0
 #define snd_hda_detach_beep_device(...)
 #endif
 #endif
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index a378c01..d586600 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -31,6 +31,7 @@
 #include "hda_codec.h"
 #include "hda_local.h"
 #include "hda_patch.h"
+#include "hda_beep.h"
 
 #define ALC880_FRONT_EVENT		0x01
 #define ALC880_DCVOL_EVENT		0x02
@@ -2788,6 +2789,7 @@ static void alc_free(struct hda_codec *codec)
 		kfree(spec->kctl_alloc);
 	}
 	kfree(spec);
+	snd_hda_detach_beep_device(codec);
 	codec->spec = NULL; /* to be sure */
 }
 
@@ -3960,6 +3962,12 @@ static int patch_alc880(struct hda_codec *codec)
 		}
 	}
 
+	err = snd_hda_attach_beep_device(codec, 0x1);
+	if (err < 0) {
+		alc_free(codec);
+		return err;
+	}
+
 	if (board_config != ALC880_AUTO)
 		setup_preset(spec, &alc880_presets[board_config]);
 
@@ -5558,6 +5566,12 @@ static int patch_alc260(struct hda_codec *codec)
 		}
 	}
 
+	err = snd_hda_attach_beep_device(codec, 0x1);
+	if (err < 0) {
+		alc_free(codec);
+		return err;
+	}
+
 	if (board_config != ALC260_AUTO)
 		setup_preset(spec, &alc260_presets[board_config]);
 
@@ -6811,6 +6825,12 @@ static int patch_alc882(struct hda_codec *codec)
 		}
 	}
 
+	err = snd_hda_attach_beep_device(codec, 0x1);
+	if (err < 0) {
+		alc_free(codec);
+		return err;
+	}
+
 	if (board_config != ALC882_AUTO)
 		setup_preset(spec, &alc882_presets[board_config]);
 
@@ -8916,6 +8936,12 @@ static int patch_alc883(struct hda_codec *codec)
 		}
 	}
 
+	err = snd_hda_attach_beep_device(codec, 0x1);
+	if (err < 0) {
+		alc_free(codec);
+		return err;
+	}
+
 	if (board_config != ALC883_AUTO)
 		setup_preset(spec, &alc883_presets[board_config]);
 
@@ -10739,6 +10765,12 @@ static int patch_alc262(struct hda_codec *codec)
 		}
 	}
 
+	err = snd_hda_attach_beep_device(codec, 0x1);
+	if (err < 0) {
+		alc_free(codec);
+		return err;
+	}
+
 	if (board_config != ALC262_AUTO)
 		setup_preset(spec, &alc262_presets[board_config]);
 
@@ -11752,6 +11784,12 @@ static int patch_alc268(struct hda_codec *codec)
 		}
 	}
 
+	err = snd_hda_attach_beep_device(codec, 0x1);
+	if (err < 0) {
+		alc_free(codec);
+		return err;
+	}
+
 	if (board_config != ALC268_AUTO)
 		setup_preset(spec, &alc268_presets[board_config]);
 
@@ -12458,6 +12496,12 @@ static int patch_alc269(struct hda_codec *codec)
 		}
 	}
 
+	err = snd_hda_attach_beep_device(codec, 0x1);
+	if (err < 0) {
+		alc_free(codec);
+		return err;
+	}
+
 	if (board_config != ALC269_AUTO)
 		setup_preset(spec, &alc269_presets[board_config]);
 
@@ -13624,6 +13668,12 @@ static int patch_alc861(struct hda_codec *codec)
 		}
 	}
 
+	err = snd_hda_attach_beep_device(codec, 0x23);
+	if (err < 0) {
+		alc_free(codec);
+		return err;
+	}
+
 	if (board_config != ALC861_AUTO)
 		setup_preset(spec, &alc861_presets[board_config]);
 
@@ -14578,6 +14628,12 @@ static int patch_alc861vd(struct hda_codec *codec)
 		}
 	}
 
+	err = snd_hda_attach_beep_device(codec, 0x23);
+	if (err < 0) {
+		alc_free(codec);
+		return err;
+	}
+
 	if (board_config != ALC861VD_AUTO)
 		setup_preset(spec, &alc861vd_presets[board_config]);
 
@@ -16412,6 +16468,12 @@ static int patch_alc662(struct hda_codec *codec)
 		}
 	}
 
+	err = snd_hda_attach_beep_device(codec, 0x1);
+	if (err < 0) {
+		alc_free(codec);
+		return err;
+	}
+
 	if (board_config != ALC662_AUTO)
 		setup_preset(spec, &alc662_presets[board_config]);
 
-- 
1.5.6.5

