Return-Path: <linux-kernel-owner+w=401wt.eu-S1753149AbXJ3Dvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbXJ3Dvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 23:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbXJ3Dvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 23:51:40 -0400
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:45523 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbXJ3Dvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 23:51:40 -0400
Date: Tue, 30 Oct 2007 14:51:38 +1100
From: Tony Breeds <tony@bakeyournoodle.com>
To: Linux Kernel ML <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH] Update zfcp_sg_to_address() for new SG chanegs.
Message-ID: <20071030035138.GV24243@bakeyournoodle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 642f149031d70415d9318b919d50b71e4724adbd Added args to
zfcp_sg_to_address() but didn't update the defn. to know about them.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
---

Only compile tested.

 drivers/s390/scsi/zfcp_def.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
index 0754542..e70cd95 100644
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -70,11 +70,12 @@ zfcp_sg_to_address(struct scatterlist *list)
  * zfcp_address_to_sg - set up struct scatterlist from kernel address
  * @address: kernel address
  * @list: struct scatterlist
+ * @len: buffer length
  */
 static inline void
-zfcp_address_to_sg(void *address, struct scatterlist *list)
+zfcp_address_to_sg(void *address, struct scatterlist *list, unsigned int len)
 {
-	sg_set_buf(list, address, 0);
+	sg_set_buf(list, address, len);
 }
 
 #define REQUEST_LIST_SIZE 128
-- 
1.5.3.4

Yours Tony

  linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
  Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!

