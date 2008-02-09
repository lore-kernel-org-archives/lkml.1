Return-Path: <linux-kernel-owner+w=401wt.eu-S1757012AbYBIO7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012AbYBIO7s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 09:59:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754581AbYBIO7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 09:59:41 -0500
Received: from web36710.mail.mud.yahoo.com ([209.191.85.44]:48826 "HELO
	web36710.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753568AbYBIO7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 09:59:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=oCSdLz1QwaL/v5nx3XWjRDfoYuoaWjtozhEjVLfRfx0oVdrclXfnvL4a/Vvtcn46E27suiaNTJYgFfcxJ0HAKtA7hcouHNdLsedOKKWtAsRrU+1fXnWXwveEHdrmIlX03mk7IeTVMKiUb6O8mhwfDU8xzvCBVkXmfEQYkLYMJyQ=;
X-YMail-OSG: .H.pODYVM1n5N1vwIvwtLjnW8TSX998oZHgQNY0ppHBftnbBvM2l8QpmGfG_If.20.Wo41uvArWpSn3pplR2_d1HWaMMaJqZ5fHjjxwqxnqGumY-
Date: Sat, 9 Feb 2008 06:59:40 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: [PATCH] memstick: fix attribute structure casting in mspro_block_resume
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080203230705.581a3315.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <159595.47470.qm@web36710.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alex Dubov <oakad@yahoo.com>
---
 drivers/memstick/core/mspro_block.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index b9bd0aa..423ad8c 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -1237,7 +1237,7 @@ static int mspro_block_resume(struct memstick_dev *card)
 
 	struct mspro_block_data *new_msb;
 	struct memstick_host *host = card->host;
-	struct mspro_sys_attr s_attr, r_attr;
+	struct mspro_sys_attr *s_attr, *r_attr;
 	unsigned char cnt;
 
 	mutex_lock(&host->lock);
@@ -1254,12 +1254,8 @@ static int mspro_block_resume(struct memstick_dev *card)
 
 	for (cnt = 0; new_msb->attr_group.attrs[cnt]
 		      && msb->attr_group.attrs[cnt]; ++cnt) {
-		s_attr = container_of(new_msb->attr_group.attrs[cnt],
-				      struct mspro_sys_attr,
-				      dev_attr);
-		r_attr = container_of(msb->attr_group.attrs[cnt],
-				      struct mspro_sys_attr,
-				      dev_attr);
+		s_attr = mspro_from_sysfs_attr(new_msb->attr_group.attrs[cnt]);
+		r_attr = mspro_from_sysfs_attr(msb->attr_group.attrs[cnt]);
 
 		if (s_attr->id == MSPRO_BLOCK_ID_SYSINFO
 		    && r_attr->id == s_attr->id) {
-- 
1.5.3.6


      ____________________________________________________________________________________
Looking for last minute shopping deals?  
Find them fast with Yahoo! Search.  http://tools.search.yahoo.com/newsearch/category.php?category=shopping
