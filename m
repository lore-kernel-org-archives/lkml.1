Return-Path: <linux-kernel-owner+w=401wt.eu-S1752444AbXJ2FJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbXJ2FJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 01:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754983AbXJ2FIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 01:08:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35940 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbXJ2FIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 01:08:49 -0400
To: torvalds@linux-foundation.org
Subject: arcmsr: endianness bug
Cc: nick.cheng@areca.com.tw, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Message-Id: <E1ImMro-0003T4-Pk@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Mon, 29 Oct 2007 05:08:48 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


initializing a field in data shared with the card with
cpu_to_le32(something) | 0x100000 is broken - the field
is, indeed, little-endian and we need cpu_to_le32() on
both parts.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/scsi/arcmsr/arcmsr_hba.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 152af46..acbc50f 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -932,7 +932,7 @@ static void arcmsr_build_ccb(struct AdapterControlBlock *acb,
 
 				pdma_sg->addresshigh = address_hi;
 				pdma_sg->address = address_lo;
-				pdma_sg->length = length|IS_SG64_ADDR;
+				pdma_sg->length = length|cpu_to_le32(IS_SG64_ADDR);
 				psge += sizeof (struct SG64ENTRY);
 				arccdbsize += sizeof (struct SG64ENTRY);
 			}
-- 
1.5.3.GIT


