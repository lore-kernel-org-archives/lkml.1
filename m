Return-Path: <linux-kernel-owner+w=401wt.eu-S1754355AbZBFDFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbZBFDFR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 22:05:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbZBFDFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 22:05:00 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52636 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbZBFDE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 22:04:59 -0500
Message-ID: <498BA8D5.2000606@cn.fujitsu.com>
Date: Fri, 06 Feb 2009 11:04:53 +0800
From: Wei Yongjun <yjwei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: scsi: used kmem_cache_zalloc instead of kmem_cache_alloc/memset
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used kmem_cache_zalloc instead of kmem_cache_alloc/memset.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 drivers/scsi/scsi.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index cbcd3f6..fbe6672 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -169,12 +169,10 @@ scsi_pool_alloc_command(struct scsi_host_cmd_pool *pool, gfp_t gfp_mask)
 {
 	struct scsi_cmnd *cmd;
 
-	cmd = kmem_cache_alloc(pool->cmd_slab, gfp_mask | pool->gfp_mask);
+	cmd = kmem_cache_zalloc(pool->cmd_slab, gfp_mask | pool->gfp_mask);
 	if (!cmd)
 		return NULL;
 
-	memset(cmd, 0, sizeof(*cmd));
-
 	cmd->sense_buffer = kmem_cache_alloc(pool->sense_slab,
 					     gfp_mask | pool->gfp_mask);
 	if (!cmd->sense_buffer) {
-- 
1.5.3.8



