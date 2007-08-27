Return-Path: <linux-kernel-owner+w=401wt.eu-S1765261AbXH0V3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765261AbXH0V3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764689AbXH0V1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:27:21 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:58793 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764436AbXH0V1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:27:19 -0400
Date: Mon, 27 Aug 2007 23:27:18 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, perex@suse.cz
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] unexport snd_ctl_elem_{read,write}
Message-ID: <20070827212718.GL4121@stusta.de>
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
>  git-alsa.patch
>...
>  git trees
>...

snd_ctl_elem_{read,write} no longer have any modular users.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 sound/core/control.c |    4 ----
 1 file changed, 4 deletions(-)

23e15051dde57c569e4c9aff1339aaf64185ea71 
diff --git a/sound/core/control.c b/sound/core/control.c
index 396e98e..6144d8a 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -716,8 +716,6 @@ int snd_ctl_elem_read(struct snd_card *card, struct snd_ctl_elem_value *control)
 	return result;
 }
 
-EXPORT_SYMBOL(snd_ctl_elem_read);
-
 static int snd_ctl_elem_read_user(struct snd_card *card,
 				  struct snd_ctl_elem_value __user *_control)
 {
@@ -781,8 +779,6 @@ int snd_ctl_elem_write(struct snd_card *card, struct snd_ctl_file *file,
 	return result;
 }
 
-EXPORT_SYMBOL(snd_ctl_elem_write);
-
 static int snd_ctl_elem_write_user(struct snd_ctl_file *file,
 				   struct snd_ctl_elem_value __user *_control)
 {

