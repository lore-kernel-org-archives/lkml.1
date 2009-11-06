Return-Path: <linux-kernel-owner+w=401wt.eu-S932986AbZKFWoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932986AbZKFWoy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:44:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932392AbZKFWlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:41:44 -0500
Received: from www.tglx.de ([62.245.132.106]:53976 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933139AbZKFWlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:41:42 -0500
Message-Id: <20091106223806.641098564@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 06 Nov 2009 22:41:29 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch 06/16] sound: Replace old style lock initializer
References: <20091106223547.784916750@linutronix.de>
Content-Disposition: inline;
	filename=sound-oss-replace-old-style-lock-init.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPIN_LOCK_UNLOCKED is deprecated. Use __SPIN_LOCK_UNLOCKED instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Takashi Iwai <tiwai@suse.de>
---
 sound/oss/dmasound/dmasound_core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/sound/oss/dmasound/dmasound_core.c
===================================================================
--- linux-2.6.orig/sound/oss/dmasound/dmasound_core.c
+++ linux-2.6/sound/oss/dmasound/dmasound_core.c
@@ -219,7 +219,9 @@ static int shared_resources_initialised;
      *  Mid level stuff
      */
 
-struct sound_settings dmasound = { .lock = SPIN_LOCK_UNLOCKED };
+struct sound_settings dmasound = {
+	.lock = __SPIN_LOCK_UNLOCKED(dmasound.lock)
+};
 
 static inline void sound_silence(void)
 {


