Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbXH0Vla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbXH0Vla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756523AbXH0V3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:29:31 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:58871 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765524AbXH0V3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:29:30 -0400
Date: Mon, 27 Aug 2007 23:29:29 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, mchehab@infradead.org
Cc: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org
Subject: [-mm patch] ivtv-fb.c bugfix
Message-ID: <20070827212929.GH26410@stusta.de>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070822020648.5ea3a612.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 02:06:48AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.23-rc2-mm2:
>...
>  git-dvb.patch
>...
>  git trees
>...

This patch fixes an obvious bug in ivtvfb_release_buffers().

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
093bdc9ba94bffbec2ed44743418899771488832 
diff --git a/drivers/media/video/ivtv/ivtv-fb.c b/drivers/media/video/ivtv/ivtv-fb.c
index 0080765..8a344d5 100644
--- a/drivers/media/video/ivtv/ivtv-fb.c
+++ b/drivers/media/video/ivtv/ivtv-fb.c
@@ -1068,8 +1068,8 @@ static void ivtvfb_release_buffers (struct ivtv *itv)
 	struct osd_info *oi = itv->osd_info;
 
 	/* Release cmap */
-	if (oi->ivtvfb_info.cmap.len);
-	fb_dealloc_cmap(&oi->ivtvfb_info.cmap);
+	if (oi->ivtvfb_info.cmap.len)
+		fb_dealloc_cmap(&oi->ivtvfb_info.cmap);
 
 	/* Release pseudo palette */
 	if (oi->ivtvfb_info.pseudo_palette)

