Return-Path: <linux-kernel-owner+w=401wt.eu-S1751710AbZJLFI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbZJLFI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 01:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbZJLFI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 01:08:57 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56736 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbZJLFI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 01:08:57 -0400
Date: Mon, 12 Oct 2009 16:08:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Lydia Wang <lydiawang@viatech.com.cn>,
       Logan Li <loganli@viatech.com.cn>
Subject: linux-next: sound tree build failure
Message-Id: <20091012160816.90fe936d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

Today's linux-next build (i386 defconfig) failed like this:

sound/pci/hda/patch_via.c: In function 'patch_vt1718S':
sound/pci/hda/patch_via.c:4951: error: expected expression before 'return'

Caused by commit eb7188cafcb7aa1419b8889494cdbd4e6a01da1c ("ALSA: HDA
VIA: Add VT1718S support").

sound/pci/hda/patch_via.c: In function 'patch_vt1716S':
sound/pci/hda/patch_via.c:5441: error: expected expression before 'return'

Caused by commit f3db423df84570c9950754a5771ad26f0111235f ("ALSA: HDA
VIA: Add VT1716S support").

sound/pci/hda/patch_via.c: In function 'patch_vt2002P':
sound/pci/hda/patch_via.c:5794: error: expected expression before 'return'

Caused by commit 25eaba2f8a6877ba6f58197c4723c2433a316e09 ("ALSA: HDA VIA: Add VT2002P support").

sound/pci/hda/patch_via.c: In function 'patch_vt1812':
sound/pci/hda/patch_via.c:6148: error: expected expression before 'return'

Caused by commit ab6734e7ea32e9f9cbe0f55eeddf4aa629ed1c3d ("ALSA: HDA VIA: Add VT1812 support").

I applied the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 12 Oct 2009 15:56:17 +1100
Subject: [PATCH] sound: use semicolons to end statements

Fixes:

sound/pci/hda/patch_via.c: In function 'patch_vt1718S':
sound/pci/hda/patch_via.c:4951: error: expected expression before 'return'
sound/pci/hda/patch_via.c: In function 'patch_vt1716S':
sound/pci/hda/patch_via.c:5441: error: expected expression before 'return'
sound/pci/hda/patch_via.c: In function 'patch_vt2002P':
sound/pci/hda/patch_via.c:5794: error: expected expression before 'return'
sound/pci/hda/patch_via.c: In function 'patch_vt1812':
sound/pci/hda/patch_via.c:6148: error: expected expression before 'return'

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 sound/pci/hda/patch_via.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/pci/hda/patch_via.c b/sound/pci/hda/patch_via.c
index 30260e2..a294060 100644
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -4942,7 +4942,7 @@ static int patch_vt1718S(struct hda_codec *codec)
 	codec->patch_ops = via_patch_ops;
 
 	codec->patch_ops.init = via_auto_init;
-	codec->patch_ops.unsol_event = via_unsol_event,
+	codec->patch_ops.unsol_event = via_unsol_event;
 
 #ifdef CONFIG_SND_HDA_POWER_SAVE
 	spec->loopback.amplist = vt1718S_loopbacks;
@@ -5432,7 +5432,7 @@ static int patch_vt1716S(struct hda_codec *codec)
 	codec->patch_ops = via_patch_ops;
 
 	codec->patch_ops.init = via_auto_init;
-	codec->patch_ops.unsol_event = via_unsol_event,
+	codec->patch_ops.unsol_event = via_unsol_event;
 
 #ifdef CONFIG_SND_HDA_POWER_SAVE
 	spec->loopback.amplist = vt1716S_loopbacks;
@@ -5785,7 +5785,7 @@ static int patch_vt2002P(struct hda_codec *codec)
 	codec->patch_ops = via_patch_ops;
 
 	codec->patch_ops.init = via_auto_init;
-	codec->patch_ops.unsol_event = via_unsol_event,
+	codec->patch_ops.unsol_event = via_unsol_event;
 
 #ifdef CONFIG_SND_HDA_POWER_SAVE
 	spec->loopback.amplist = vt2002P_loopbacks;
@@ -6139,7 +6139,7 @@ static int patch_vt1812(struct hda_codec *codec)
 	codec->patch_ops = via_patch_ops;
 
 	codec->patch_ops.init = via_auto_init;
-	codec->patch_ops.unsol_event = via_unsol_event,
+	codec->patch_ops.unsol_event = via_unsol_event;
 
 #ifdef CONFIG_SND_HDA_POWER_SAVE
 	spec->loopback.amplist = vt1812_loopbacks;
-- 
1.6.4.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
