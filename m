Return-Path: <linux-kernel-owner+w=401wt.eu-S1758456AbYGOMoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456AbYGOMoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757694AbYGOMoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:44:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:32475 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757468AbYGOMo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:44:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=KKfjc3Jf8DzGxqPy3pjGdTAj/2Foe626WLrdduedUK6ov3IjvRw6ygLXgj/3VAoTao
         3dtju/vljbdbxWBBJ0j/dGF3aNGm4Jvhu8uKzPCaC3bmo3B7cmMn3gPjne8CvkHR9ajj
         bdLt5UcOTJ6nmDFm7RCs8dwbwAhtP2uGHS5tw=
Message-ID: <487C9BA8.5010709@gmail.com>
Date: Tue, 15 Jul 2008 14:44:24 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: mano@roarinelk.homelinux.net
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH]  ALSA Au1xpsc: psc not disabled when TX is idle
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Untested patch
---
TX idleness isn't tested, but RX twice. PSC is not disabled when TX is idle

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/sound/soc/au1x/psc-i2s.c b/sound/soc/au1x/psc-i2s.c
index ba4b5c1..9384702 100644
--- a/sound/soc/au1x/psc-i2s.c
+++ b/sound/soc/au1x/psc-i2s.c
@@ -231,7 +231,7 @@ static int au1xpsc_i2s_stop(struct au1xpsc_audio_data *pscdata, int stype)

        /* if both TX and RX are idle, disable PSC */
        stat = au_readl(I2S_STAT(pscdata));
-       if (!(stat & (PSC_I2SSTAT_RB | PSC_I2SSTAT_RB))) {
+       if (!(stat & (PSC_I2SSTAT_TB | PSC_I2SSTAT_RB))) {
                au_writel(0, I2S_CFG(pscdata));
                au_sync();
                au_writel(PSC_CTRL_SUSPEND, PSC_CTRL(pscdata));
