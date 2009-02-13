Return-Path: <linux-kernel-owner+w=401wt.eu-S1759291AbZBMOCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291AbZBMOCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 09:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbZBMOCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 09:02:35 -0500
Received: from perninha.conectiva.com.br ([200.140.247.100]:54948 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935AbZBMOCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 09:02:35 -0500
X-Greylist: delayed 1653 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Feb 2009 09:02:34 EST
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: [PATCH 1/2] Staging: agnx: mac80211 hw config change flags
Date: Fri, 13 Feb 2009 08:35:12 -0500
Message-Id: <1234532113-14081-1-git-send-email-herton@mandriva.com.br>
X-Mailer: git-send-email 1.6.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adapt agnx after commit "mac80211: introduce hw config change flags",
detected by following build warning:
drivers/staging/agnx/pci.c:426: warning: initialization from incompatible pointer type

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 drivers/staging/agnx/pci.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/agnx/pci.c b/drivers/staging/agnx/pci.c
index 854630c..be63f08 100644
--- a/drivers/staging/agnx/pci.c
+++ b/drivers/staging/agnx/pci.c
@@ -286,10 +286,10 @@ static void agnx_stop(struct ieee80211_hw *dev)
 	rings_free(priv);
 }
 
-static int agnx_config(struct ieee80211_hw *dev,
-		       struct ieee80211_conf *conf)
+static int agnx_config(struct ieee80211_hw *dev, u32 changed)
 {
 	struct agnx_priv *priv = dev->priv;
+	struct ieee80211_conf *conf = &dev->conf;
 	int channel = ieee80211_frequency_to_channel(conf->channel->center_freq);
 	AGNX_TRACE;
 
-- 
1.6.1.3

