Return-Path: <linux-kernel-owner+w=401wt.eu-S932227Ab0AFOL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab0AFOL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 09:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755844Ab0AFOL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 09:11:56 -0500
Received: from mail-iw0-f194.google.com ([209.85.223.194]:61388 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab0AFOLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 09:11:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=sOkUX844PzUNGQjeNYGp1wGdn/DapkHtax0XH/USpKrV63jpPZzzxDgKU8ZHYQZA0c
         IrD8um0LRlr3H8uf6y22TiVS81eRm7r4TNHhfh3a1kZBqfhAh6oN+oTydabtcm+unn8i
         pZcQqBFmA6hNV7pwNxyv4KFi1RjP5IaS9bzy8=
MIME-Version: 1.0
Date: Wed, 6 Jan 2010 22:11:54 +0800
Message-ID: <b3657a101001060611k57407d6aj94f5931a2f0a5f33@mail.gmail.com>
Subject: [PATCH]btrfs: Remove a extra condition
From: liu weni <qingshenlwy@gmail.com>
To: linux-btrfs@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       zheng.yan@oracle.com, chris.mason@oracle.com,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       strongzgy <strongzgy@gmail.com>, Liu Hui <onlyflyer@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove a extra condition.
In this place, the outer is if (!cur || !uptodate)
and then, there are 2 ways: !cur or ! uptodate.
The "else if (!uptodate)" is not necessary.
I think "else" is better.

---
Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>

---
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index c4bc570..654f702 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -679,7 +679,7 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 			if (!cur) {
 				cur = read_tree_block(root, blocknr,
 							 blocksize, gen);
-			} else if (!uptodate) {
+			} else {
 				btrfs_read_buffer(cur, gen);
 			}
 		}
---

Best Regards,
Liuwenyi
20100107
