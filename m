Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334AbYKRISD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbYKRISD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 03:18:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbYKRIRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 03:17:00 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:52075 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbYKRIQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 03:16:58 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62691574"
From: Bryan Wu <cooloney@kernel.org>
To: broonie@sirena.org.uk, tiwai@suse.de
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Cliff Cai <cliff.cai@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 5/8] ASoC: Fix BUGS in Blackfin AC97 DAI
Date: Tue, 18 Nov 2008 16:18:19 +0800
Message-Id: <1226996302-10234-6-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1226996302-10234-1-git-send-email-cooloney@kernel.org>
References: <1226996302-10234-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

sport_handle is a global and not allocated my kmalloc.
A probe function should have a clean return 0 path.

Cc: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 sound/soc/blackfin/bf5xx-ac97.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sound/soc/blackfin/bf5xx-ac97.c b/sound/soc/blackfin/bf5xx-ac97.c
index 65c162c..5dcd3f6 100644
--- a/sound/soc/blackfin/bf5xx-ac97.c
+++ b/sound/soc/blackfin/bf5xx-ac97.c
@@ -378,6 +378,8 @@ static int bf5xx_ac97_probe(struct platform_device *pdev,
 		goto sport_config_err;
 	}
 
+	return 0;
+
 sport_config_err:
 	kfree(sport_handle);
 sport_err:
-- 
1.5.6.3
