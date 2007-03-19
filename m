Return-Path: <linux-kernel-owner+w=401wt.eu-S1752920AbXCSJZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbXCSJZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 05:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbXCSJYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 05:24:38 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34833 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753307AbXCSJYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 05:24:35 -0400
Date: Mon, 19 Mar 2007 10:24:38 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Clement Guedez <klem.dev@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@suse.cz>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [RFC: 2.6.21 patch] fix sound/pci/ice1712/wtm.c:wtm_init()
Message-ID: <20070319092438.GL752@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted this bogus for() loop that produces an 
array overrun.

It seems what actually should be done is quite simple?

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 sound/pci/ice1712/wtm.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

--- linux-2.6.21-rc3-mm2/sound/pci/ice1712/wtm.c.old	2007-03-19 01:29:23.000000000 +0100
+++ linux-2.6.21-rc3-mm2/sound/pci/ice1712/wtm.c	2007-03-19 01:33:06.000000000 +0100
@@ -489,23 +489,15 @@
 
 static int __devinit wtm_init(struct snd_ice1712 *ice)
 {
-	static unsigned short stac_inits_prodigy[] = {
-		STAC946X_RESET, 0,
-		(unsigned short)-1
-	};
-	unsigned short *p;
-		
 	/*WTM 192M*/
 	ice->num_total_dacs = 8;
 	ice->num_total_adcs = 4;
 	ice->force_rdma1 = 1;
 
 	/*initialize codec*/
-	p = stac_inits_prodigy;
-	for (; *p != (unsigned short)-1; p += 2) {
-		stac9460_put(ice, p[0], p[1]);
-		stac9460_2_put(ice, p[0], p[1]);
-	}
+	stac9460_put(ice, STAC946X_RESET, 0);
+	stac9460_2_put(ice, STAC946X_RESET, 0);
+
 	return 0;
 }
 

