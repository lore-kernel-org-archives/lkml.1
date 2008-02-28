Return-Path: <linux-kernel-owner+w=401wt.eu-S1761150AbYB1TMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761150AbYB1TMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760584AbYB1TL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:11:26 -0500
Received: from el-out-1112.google.com ([209.85.162.181]:4689 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760327AbYB1TLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:11:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CWqJU03pIoRRrS+xNvowjdLrk4fDt/wjH0TyWiJiTxEn53yYP+NLph5ZQK2uGMux2cYJq1T6a34i/OHU9XKSUTPnTOPbsuP7PEbtxDpi3cjxl2EPdNCEDlFB0ztoglqCcpSQt1FDX9EmSACZ5+NIQrjW5LHmIHU/DJAjogThICs=
Subject: [PATCH 7/8] sound: riptide.c fix shadowed variable warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 11:11:14 -0800
Message-Id: <1204225874.20280.87.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In both cases we are passing around the substream number, use
sub_num for this.
sound/pci/riptide/riptide.c:1633:6: warning: symbol 'index' shadows an earlier one
sound/pci/riptide/riptide.c:121:12: originally declared here
sound/pci/riptide/riptide.c:1673:6: warning: symbol 'index' shadows an earlier one
sound/pci/riptide/riptide.c:121:12: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 sound/pci/riptide/riptide.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/sound/pci/riptide/riptide.c b/sound/pci/riptide/riptide.c
index 9408b1e..979f7da 100644
--- a/sound/pci/riptide/riptide.c
+++ b/sound/pci/riptide/riptide.c
@@ -1630,14 +1630,14 @@ static int snd_riptide_playback_open(struct snd_pcm_substream *substream)
 	struct snd_riptide *chip = snd_pcm_substream_chip(substream);
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct pcmhw *data;
-	int index = substream->number;
+	int sub_num = substream->number;
 
-	chip->playback_substream[index] = substream;
+	chip->playback_substream[sub_num] = substream;
 	runtime->hw = snd_riptide_playback;
 	data = kzalloc(sizeof(struct pcmhw), GFP_KERNEL);
-	data->paths = lbus_play_paths[index];
-	data->id = play_ids[index];
-	data->source = play_sources[index];
+	data->paths = lbus_play_paths[sub_num];
+	data->id = play_ids[sub_num];
+	data->source = play_sources[sub_num];
 	data->intdec[0] = 0xff;
 	data->intdec[1] = 0xff;
 	data->state = ST_STOP;
@@ -1670,10 +1670,10 @@ static int snd_riptide_playback_close(struct snd_pcm_substream *substream)
 {
 	struct snd_riptide *chip = snd_pcm_substream_chip(substream);
 	struct pcmhw *data = get_pcmhwdev(substream);
-	int index = substream->number;
+	int sub_num = substream->number;
 
 	substream->runtime->private_data = NULL;
-	chip->playback_substream[index] = NULL;
+	chip->playback_substream[sub_num] = NULL;
 	kfree(data);
 	return 0;
 }
-- 
1.5.4.3.342.g99e8


