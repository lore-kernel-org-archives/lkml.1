Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702AbYICIi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbYICIi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 04:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbYICIit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 04:38:49 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:60520 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbYICIit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 04:38:49 -0400
X-IronPort-AV: E=Sophos;i="4.32,320,1217822400"; 
   d="scan'208";a="74501216"
From: Bryan Wu <cooloney@kernel.org>
To: tiwai@suse.de
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Cliff Cai <cliff.cai@analog.com>, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/1] ALSA: add dummy function to support shared mmap in nommu Blackfin arch (v3)
Date: Wed,  3 Sep 2008 16:38:54 +0800
Message-Id: <1220431134-7797-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Cai <cliff.cai@analog.com>

v2-v3:
 - when it is mmu arch, we define the dummy function to NULL

v1-v2:
 - only adding this dummy function in nommu arch

Cc: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 sound/core/pcm_native.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index c49b9d9..e2068a4 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3391,6 +3391,16 @@ out:
 }
 #endif /* CONFIG_SND_SUPPORT_OLD_API */
 
+#ifndef CONFIG_MMU
+unsigned long dummy_get_unmapped_area(struct file *file, unsigned long addr,
+				      unsigned long len, unsigned long pgoff, unsigned long flags)
+{
+	return 0;
+}
+#else
+# define dummy_get_unmapped_area NULL
+#endif
+
 /*
  *  Register section
  */
@@ -3407,6 +3417,7 @@ const struct file_operations snd_pcm_f_ops[2] = {
 		.compat_ioctl = 	snd_pcm_ioctl_compat,
 		.mmap =			snd_pcm_mmap,
 		.fasync =		snd_pcm_fasync,
+		.get_unmapped_area =	dummy_get_unmapped_area,
 	},
 	{
 		.owner =		THIS_MODULE,
@@ -3419,5 +3430,6 @@ const struct file_operations snd_pcm_f_ops[2] = {
 		.compat_ioctl = 	snd_pcm_ioctl_compat,
 		.mmap =			snd_pcm_mmap,
 		.fasync =		snd_pcm_fasync,
+		.get_unmapped_area =	dummy_get_unmapped_area,
 	}
 };
-- 
1.5.6
