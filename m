Return-Path: <linux-kernel-owner+w=401wt.eu-S933904AbZHHJf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933904AbZHHJf7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 05:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933779AbZHHJf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 05:35:59 -0400
Received: from server1.wserver.cz ([82.113.45.157]:58265 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933770AbZHHJf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 05:35:58 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>,
       YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Subject: [PATCH] SCSI: pcmcia, fix buf overflow
Date: Sat,  8 Aug 2009 11:36:06 +0200
Message-Id: <1249724166-1150-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In nsp_cs_config there is a wrong struct nsp_cs_configdata allocation.
It allocates only sizeof(pointer to nsp_cs_configdata) for a whole
structure. Add a dereference to the sizeof to allocate
sizeof(nsp_cs_configdata).

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
---
 drivers/scsi/pcmcia/nsp_cs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 70b60ad..e32c344 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -1713,7 +1713,7 @@ static int nsp_cs_config(struct pcmcia_device *link)
 
 	nsp_dbg(NSP_DEBUG_INIT, "in");
 
-	cfg_mem = kzalloc(sizeof(cfg_mem), GFP_KERNEL);
+	cfg_mem = kzalloc(sizeof(*cfg_mem), GFP_KERNEL);
 	if (!cfg_mem)
 		return -ENOMEM;
 	cfg_mem->data = data;
-- 
1.6.3.3

