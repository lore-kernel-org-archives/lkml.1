Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbYBDVIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbYBDVIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 16:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbYBDVIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 16:08:09 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:53614 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbYBDVII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 16:08:08 -0500
Message-ID: <47A77EB2.6070703@tiscali.nl>
Date: Mon, 04 Feb 2008 22:08:02 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: liam.girdwood@wolfsonmicro.com, broonie@opensource.wolfsonmicro.com
CC: alsa-devel@alsa-project.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH][sound/soc/fsl/mpc8610_hpcd.c] duplicate strcasecmp test for
 "rj-master" in mpc8610_hpcd_probe()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In linus' git tree I found this problem. Is it also in the alsa tree?
please confirm it's the right fix. The patch was not yet tested.
--
duplicate test for "rj-master"

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/sound/soc/fsl/mpc8610_hpcd.c b/sound/soc/fsl/mpc8610_hpcd.c
index f26c4b2..a00aac7 100644
--- a/sound/soc/fsl/mpc8610_hpcd.c
+++ b/sound/soc/fsl/mpc8610_hpcd.c
@@ -314,9 +314,9 @@ static int mpc8610_hpcd_probe(struct of_device *ofdev,
 	} else if (strcasecmp(sprop, "lj-master") == 0) {
 		machine_data->dai_format = SND_SOC_DAIFMT_LEFT_J;
 		machine_data->codec_clk_direction = SND_SOC_CLOCK_IN;
 		machine_data->cpu_clk_direction = SND_SOC_CLOCK_OUT;
-	} else if (strcasecmp(sprop, "rj-master") == 0) {
+	} else if (strcasecmp(sprop, "rj-slave") == 0) {
 		machine_data->dai_format = SND_SOC_DAIFMT_RIGHT_J;
 		machine_data->codec_clk_direction = SND_SOC_CLOCK_OUT;
 		machine_data->cpu_clk_direction = SND_SOC_CLOCK_IN;
 	} else if (strcasecmp(sprop, "rj-master") == 0) {
