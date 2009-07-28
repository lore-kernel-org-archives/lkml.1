Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbZG1X6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbZG1X6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282AbZG1Xt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:49:57 -0400
Received: from kroah.org ([198.145.64.141]:35746 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246AbZG1Xt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:49:56 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:55 2009
Message-Id: <20090728234155.335851804@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:40:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [patch 27/71] ASoC: Fix register cache initialisation for WM8753
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=asoc-fix-register-cache-initialisation-for-wm8753.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 1df892cba45f9856d369a6a317ad2d1e44bca423 upstream.

The wrong register cache variable was being used to provide the size for
the memcpy(), resulting in a copy of only a void * of data.

Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8753.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/wm8753.c
+++ b/sound/soc/codecs/wm8753.c
@@ -1664,7 +1664,7 @@ static int wm8753_register(struct wm8753
 	codec->reg_cache = &wm8753->reg_cache;
 	codec->private_data = wm8753;
 
-	memcpy(codec->reg_cache, wm8753_reg, sizeof(codec->reg_cache));
+	memcpy(codec->reg_cache, wm8753_reg, sizeof(wm8753->reg_cache));
 	INIT_DELAYED_WORK(&codec->delayed_work, wm8753_work);
 
 	ret = wm8753_reset(codec);


