Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbZFDOQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbZFDOQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 10:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754783AbZFDOP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 10:15:58 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:34721 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbZFDOPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 10:15:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:date:subject:mime-version:x-uid:x-length:to
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=kjKGy03lbNmpwYaH6oCKpYze00Llrw6ZMgplguYuVOGS6nAokikmJTqOKdEiGtZu1p
         1f5p+woszKGMWFyEuRdfXpW0gDGm1hefPT0yZ/4kKG2te7AKXDewEQZNPmi2YZ+aMLgj
         K5kQU3GN7gQU9oEhBjwN1LmwFngb8CnMHHQ94=
From: Florian Fainelli <florian@openwrt.org>
Date: Thu, 4 Jun 2009 16:15:46 +0200
Subject: [PATCH 2/8] sound/core/pcm_timer.c: use lib/gcd.c
MIME-Version: 1.0
X-Length: 1920
To: "Linux-MIPS" <linux-mips@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>,
       Ralf Baechle <ralf@linux-mips.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906041615.46679.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes sound/core/pcm_timer.c use lib/gcd.c

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
diff --git a/sound/core/Kconfig b/sound/core/Kconfig
index 7bbdda0..0ae2485 100644
--- a/sound/core/Kconfig
+++ b/sound/core/Kconfig
@@ -5,6 +5,7 @@ config SND_TIMER
 config SND_PCM
 	tristate
 	select SND_TIMER
+	select GCD
 
 config SND_HWDEP
 	tristate
diff --git a/sound/core/pcm_timer.c b/sound/core/pcm_timer.c
index ca8068b..b01d948 100644
--- a/sound/core/pcm_timer.c
+++ b/sound/core/pcm_timer.c
@@ -20,6 +20,7 @@
  */
 
 #include <linux/time.h>
+#include <linux/gcd.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/timer.h>
@@ -28,22 +29,6 @@
  *  Timer functions
  */
 
-/* Greatest common divisor */
-static unsigned long gcd(unsigned long a, unsigned long b)
-{
-	unsigned long r;
-	if (a < b) {
-		r = a;
-		a = b;
-		b = r;
-	}
-	while ((r = a % b) != 0) {
-		a = b;
-		b = r;
-	}
-	return b;
-}
-
 void snd_pcm_timer_resolution_change(struct snd_pcm_substream *substream)
 {
 	unsigned long rate, mult, fsize, l, post;
