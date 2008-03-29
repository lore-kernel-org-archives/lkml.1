Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbYC2U4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbYC2U4b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 16:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbYC2U4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 16:56:24 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33347 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbYC2U4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 16:56:23 -0400
Date: Sat, 29 Mar 2008 21:57:00 +0100
From: Pavel Machek <pavel@suse.cz>
To: perex@perex.cz, kernel list <linux-kernel@vger.kernel.org>,
       Trivial patch monkey <trivial@kernel.org>, tiwai@suse.de
Subject: sound/core.h: evil #ifdefs
Message-ID: <20080329205700.GA11295@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

snd_minor_info_oss_* is an function returning int _or_ comment,
depending on config parameters. That is truly evil, fix it.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/include/sound/core.h b/include/sound/core.h
index 4fc0235..452000d 100644
--- a/include/sound/core.h
+++ b/include/sound/core.h
@@ -277,8 +277,8 @@ #ifdef CONFIG_SND_OSSEMUL
 int snd_minor_info_oss_init(void);
 int snd_minor_info_oss_done(void);
 #else
-#define snd_minor_info_oss_init() /*NOP*/
-#define snd_minor_info_oss_done() /*NOP*/
+static inline snd_minor_info_oss_init(void) { return 0; }
+static inline snd_minor_info_oss_done(void) { return 0; }
 #endif
 
 /* memory.c */

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
