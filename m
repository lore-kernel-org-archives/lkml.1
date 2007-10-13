Return-Path: <linux-kernel-owner+w=401wt.eu-S1760445AbXJMQ2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760445AbXJMQ2r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 12:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753542AbXJMQ2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 12:28:41 -0400
Received: from wx-out-0506.google.com ([66.249.82.226]:18969 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbXJMQ2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 12:28:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=X3IXAIqJLP6jMownrc8MBF5N+aHxb8gJbvsHLMfyhlf3g4cGCqwx8ni7vFlO8yKOIHbPxkTsN3MYHwWL4n1qJJZBaXIB0rfVNTj4Uw+UAo/12CZH0e5P/3V2FJ5V6SgfvDql8JTuleCbzwjZfPS/1mm2Wdu/zws0WyLiHJp2fMU=
Message-ID: <4710F1E8.6090103@gmail.com>
Date: Sat, 13 Oct 2007 12:27:20 -0400
From: Florin Malita <fmalita@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070926)
MIME-Version: 1.0
To: drzeus-mmc@drzeus.cx
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] mmc: possible leak in mmc_read_ext_csd
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The exception path associated with an invalid ext_csd_struct returns 
without freeing ext_csd.

Coverity CID 1909.

Signed-off-by: Florin Malita
---

 drivers/mmc/core/mmc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 65fe288..68c0e3b 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -213,7 +213,8 @@ static int mmc_read_ext_csd(struct mmc_card *card)
 		printk(KERN_ERR "%s: unrecognised EXT_CSD structure "
 			"version %d\n", mmc_hostname(card->host),
 			ext_csd_struct);
-		return -EINVAL;
+		err = -EINVAL;
+		goto out;
 	}
 
 	if (ext_csd_struct >= 2) {

