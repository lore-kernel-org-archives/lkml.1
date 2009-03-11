Return-Path: <linux-kernel-owner+w=401wt.eu-S1755299AbZCKTMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbZCKTMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 15:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbZCKTLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 15:11:48 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:39727 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbZCKTLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 15:11:48 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: tiwai@suse.de
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Jaroslav Kysela <perex@perex.cz>
Subject: [PATCH 1/2] sound: pcm_oss, fix locking typo
Date: Wed, 11 Mar 2009 20:11:40 +0100
Message-Id: <1236798701-14332-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/mutex_lock/mutex_unlock/ on 2 fail paths in snd_pcm_oss_proc_write.
Probably a typo, lock should be unlocked when leaving the function.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
---
 sound/core/oss/pcm_oss.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/core/oss/pcm_oss.c b/sound/core/oss/pcm_oss.c
index ddf83c8..dda000b 100644
--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -2887,7 +2887,7 @@ static void snd_pcm_oss_proc_write(struct snd_info_entry *entry,
 			setup = kmalloc(sizeof(*setup), GFP_KERNEL);
 			if (! setup) {
 				buffer->error = -ENOMEM;
-				mutex_lock(&pstr->oss.setup_mutex);
+				mutex_unlock(&pstr->oss.setup_mutex);
 				return;
 			}
 			if (pstr->oss.setup_list == NULL)
@@ -2901,7 +2901,7 @@ static void snd_pcm_oss_proc_write(struct snd_info_entry *entry,
 			if (! template.task_name) {
 				kfree(setup);
 				buffer->error = -ENOMEM;
-				mutex_lock(&pstr->oss.setup_mutex);
+				mutex_unlock(&pstr->oss.setup_mutex);
 				return;
 			}
 		}
-- 
1.6.2
caught by stanse

