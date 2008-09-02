Return-Path: <linux-kernel-owner+w=401wt.eu-S1753239AbYIBJ6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbYIBJ6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 05:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbYIBJ6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 05:58:31 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:14782 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbYIBJ6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 05:58:30 -0400
X-IronPort-AV: E=Sophos;i="4.32,316,1217822400"; 
   d="scan'208";a="58891495"
From: Bryan Wu <cooloney@kernel.org>
To: tiwai@suse.de
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Cliff Cai <cliff.cai@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/1] ALSA: add dummy function to support shared mmap in nommu Blackfin arch (v2)
Date: Tue,  2 Sep 2008 17:58:42 +0800
Message-Id: <1220349522-17995-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Cai <cliff.cai@analog.com>

v1-v2:
 - only adding this dummy function in nommu arch

Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 sound/core/pcm_native.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index c49b9d9..1e88cde 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3391,6 +3391,14 @@ out:
 }
 #endif /* CONFIG_SND_SUPPORT_OLD_API */
 
+#ifndef CONFIG_MMU
+unsigned long dummy_get_unmapped_area(struct file *file, unsigned long addr,
+				      unsigned long len, unsigned long pgoff, unsigned long flags)
+{
+	return 0;
+}
+#endif
+
 /*
  *  Register section
  */
@@ -3407,6 +3415,9 @@ const struct file_operations snd_pcm_f_ops[2] = {
 		.compat_ioctl = 	snd_pcm_ioctl_compat,
 		.mmap =			snd_pcm_mmap,
 		.fasync =		snd_pcm_fasync,
+#ifndef CONFIG_MMU
+		.get_unmapped_area =	dummy_get_unmapped_area,
+#endif
 	},
 	{
 		.owner =		THIS_MODULE,
@@ -3419,5 +3430,8 @@ const struct file_operations snd_pcm_f_ops[2] = {
 		.compat_ioctl = 	snd_pcm_ioctl_compat,
 		.mmap =			snd_pcm_mmap,
 		.fasync =		snd_pcm_fasync,
+#ifndef CONFIG_MMU
+		.get_unmapped_area =	dummy_get_unmapped_area,
+#endif
 	}
 };
-- 
1.5.6
