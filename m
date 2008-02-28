Return-Path: <linux-kernel-owner+w=401wt.eu-S1761100AbYB1A4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761100AbYB1A4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 19:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbYB1A4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 19:56:10 -0500
Received: from el-out-1112.google.com ([209.85.162.176]:41369 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbYB1A4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 19:56:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RKhFP0keXMY5cWDWIruc4V/DTbWFILbJT5WPtjJoXRMEr5dfLPW/i7FNOU5DrSJ+fYy9X2mCjsL2PLgJalYt+5D+nbJqxYS2EK0gRH5qc8vHVh4lgeC3t5mWvaEII4C+I99y/u7KNrqYe4UxSTO+fzV1IFOT/rl45MEMvRJygF8=
Subject: [PATCH 01/12] sound: cmipci.c fix shadowed variable warning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 16:56:04 -0800
Message-Id: <1204160164.20280.49.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A temporary variable for each mixer element is used in an initialization
loop, use the name elem_id.

sound/pci/cmipci.c:2747:26: warning: symbol 'id' shadows an earlier one
sound/pci/cmipci.c:56:13: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 sound/pci/cmipci.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/pci/cmipci.c b/sound/pci/cmipci.c
index 135f308..3e763b9 100644
--- a/sound/pci/cmipci.c
+++ b/sound/pci/cmipci.c
@@ -2744,12 +2744,12 @@ static int __devinit snd_cmipci_mixer_new(struct cmipci *cm, int pcm_spdif_devic
 	}
 
 	for (idx = 0; idx < CM_SAVED_MIXERS; idx++) {
-		struct snd_ctl_elem_id id;
+		struct snd_ctl_elem_id elem_id;
 		struct snd_kcontrol *ctl;
-		memset(&id, 0, sizeof(id));
-		id.iface = SNDRV_CTL_ELEM_IFACE_MIXER;
-		strcpy(id.name, cm_saved_mixer[idx].name);
-		if ((ctl = snd_ctl_find_id(cm->card, &id)) != NULL)
+		memset(&elem_id, 0, sizeof(elem_id));
+		elem_id.iface = SNDRV_CTL_ELEM_IFACE_MIXER;
+		strcpy(elem_id.name, cm_saved_mixer[idx].name);
+		if ((ctl = snd_ctl_find_id(cm->card, &elem_id)) != NULL)
 			cm->mixer_res_ctl[idx] = ctl;
 	}
 
-- 
1.5.4.3.342.g99e8


