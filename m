Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbYKGCFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbYKGCFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 21:05:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbYKGCFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 21:05:23 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:60737 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbYKGCFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 21:05:22 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
       Jaroslav Kysela <perex@perex.cz>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ALSA: have snd_BUG_ON() always refer to arguments
Date: Thu,  6 Nov 2008 21:05:21 -0500
Message-Id: <1226023521-10037-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The snd_BUG_ON() macro should always expand its argument even if we're
forcing it to false.  This kills off unused warnings that did not exist
before the snd_assert() -> snd_BUG_ON() conversion.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/sound/core.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/sound/core.h b/include/sound/core.h
index 35424a9..87de9fc 100644
--- a/include/sound/core.h
+++ b/include/sound/core.h
@@ -387,7 +387,7 @@ void snd_verbose_printd(const char *file, int line, const char *format, ...)
 
 #define snd_printd(fmt, args...)	/* nothing */
 #define snd_BUG()			/* nothing */
-#define snd_BUG_ON(cond)	({/*(void)(cond);*/ 0;})  /* always false */
+#define snd_BUG_ON(cond)	((cond) && 0)  /* always false */
 
 #endif /* CONFIG_SND_DEBUG */
 
-- 
1.6.0.3

