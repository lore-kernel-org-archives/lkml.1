Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbYHTAKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbYHTAKB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 20:10:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752933AbYHTAJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 20:09:53 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:1225 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbYHTAJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 20:09:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=tkJhZbxM0pN503TsqECnjZu2oYic7fqxb4hxXCUs6VBiC0viJ9BabAZKzb1kq5Ah9f
         aAozFY1zW9V/r9NqMNnSzFej9l/wKvr/b+JieyxS60jUhf4BYK/7zhG6Cr7fcXhiy0pv
         V9nPUvVVOJMWVKWlU73HWQBFHUfvI7/LbBoGA=
Subject: [PATCH] pcmcia: ds.c conversion to dev_dbg fixes
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Dominik Brodowski <linux@brodo.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 19 Aug 2008 17:09:53 -0700
Message-Id: <1219190994.17033.97.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed by sparse:
drivers/pcmcia/ds.c:962:3: warning: incorrect type in argument 1 (different base types)
drivers/pcmcia/ds.c:962:3:    expected struct device const *dev
drivers/pcmcia/ds.c:962:3:    got struct pcmcia_device *dev
drivers/pcmcia/ds.c:969:3: warning: incorrect type in argument 1 (different base types)
drivers/pcmcia/ds.c:969:3:    expected struct device const *dev
drivers/pcmcia/ds.c:969:3:    got struct pcmcia_device *dev

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Found in next-20080819

 drivers/pcmcia/ds.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pcmcia/ds.c b/drivers/pcmcia/ds.c
index ce2a7db..c848b88 100644
--- a/drivers/pcmcia/ds.c
+++ b/drivers/pcmcia/ds.c
@@ -959,14 +959,14 @@ static inline int pcmcia_devmatch(struct pcmcia_device *dev,
 		 * after it has re-checked that there is no possible module
 		 * with a prod_id/manf_id/card_id match.
 		 */
-		ds_dev_dbg(0, dev, "skipping FUNC_ID match until userspace "
+		ds_dev_dbg(0, &dev->dev, "skipping FUNC_ID match until userspace "
 		       "interaction\n");
 		if (!dev->allow_func_id_match)
 			return 0;
 	}
 
 	if (did->match_flags & PCMCIA_DEV_ID_MATCH_FAKE_CIS) {
-		ds_dev_dbg(0, dev, "device needs a fake CIS\n");
+		ds_dev_dbg(0, &dev->dev, "device needs a fake CIS\n");
 		if (!dev->socket->fake_cis)
 			pcmcia_load_firmware(dev, did->cisfile);
 
-- 
1.6.0.274.g8aacc



