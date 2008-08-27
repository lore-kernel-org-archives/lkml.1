Return-Path: <linux-kernel-owner+w=401wt.eu-S1755084AbYH0Jkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbYH0Jkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 05:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755304AbYH0Jj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 05:39:26 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:27448 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251AbYH0JjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 05:39:21 -0400
X-IronPort-AV: E=Sophos;i="4.32,278,1217822400"; 
   d="scan'208";a="74159092"
From: Bryan Wu <cooloney@kernel.org>
To: perex@perex.cz, liam.girdwood@wolfsonmicro.com,
       broonie@opensource.wolfsonmicro.com
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Cliff Cai <cliff.cai@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 4/4] ALSA: add dummy function to support shared mmap in nommu Blackfin arch
Date: Wed, 27 Aug 2008 17:39:28 +0800
Message-Id: <1219829968-6431-5-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1219829968-6431-1-git-send-email-cooloney@kernel.org>
References: <1219829968-6431-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Cai <cliff.cai@analog.com>

Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 sound/core/pcm_native.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index c49b9d9..cb202a1 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3391,6 +3391,12 @@ out:
 }
 #endif /* CONFIG_SND_SUPPORT_OLD_API */
 
+unsigned long dummy_get_unmapped_area(struct file *file, unsigned long addr,
+				      unsigned long len, unsigned long pgoff, unsigned long flags)
+{
+	return 0;
+}
+
 /*
  *  Register section
  */
@@ -3407,6 +3413,7 @@ const struct file_operations snd_pcm_f_ops[2] = {
 		.compat_ioctl = 	snd_pcm_ioctl_compat,
 		.mmap =			snd_pcm_mmap,
 		.fasync =		snd_pcm_fasync,
+		.get_unmapped_area =	dummy_get_unmapped_area,
 	},
 	{
 		.owner =		THIS_MODULE,
@@ -3419,5 +3426,6 @@ const struct file_operations snd_pcm_f_ops[2] = {
 		.compat_ioctl = 	snd_pcm_ioctl_compat,
 		.mmap =			snd_pcm_mmap,
 		.fasync =		snd_pcm_fasync,
+		.get_unmapped_area =	dummy_get_unmapped_area,
 	}
 };
-- 
1.5.6
