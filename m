Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbZKLWmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbZKLWmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 17:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbZKLWmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 17:42:12 -0500
Received: from de01.mail.all-tld.net ([195.140.232.8]:61456 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632AbZKLWmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 17:42:11 -0500
X-Greylist: delayed 2014 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Nov 2009 17:42:11 EST
Date: Thu, 12 Nov 2009 23:08:36 +0100
From: Anders Larsen <al@alarsen.net>
To: Julia Lawall <julia@diku.dk>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, trivial@kernel.org
Subject: Re: [PATCH 4/4] fs/qnx4: decrement sizeof size in strncmp
Message-ID: <20091112220836.GA3893@alarsen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-VirusScanner: Found to be clean
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: anders@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

As an identical match is wanted in this case, strcmp can be used instead.

The semantic match that lead to detecting this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression foo;
constant char *abc;
@@

*strncmp(foo, abc, sizeof(abc))
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Anders Larsen <al@alarsen.net>

---
 fs/qnx4/inode.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/qnx4/inode.c b/fs/qnx4/inode.c
index 449f5a6..150f4af 100644
--- a/fs/qnx4/inode.c
+++ b/fs/qnx4/inode.c
@@ -221,7 +221,8 @@ static const char *qnx4_checkroot(struct super_block *sb)
 				rootdir = (struct qnx4_inode_entry *) (bh->b_data + i * QNX4_DIR_ENTRY_SIZE);
 				if (rootdir->di_fname != NULL) {
 					QNX4DEBUG((KERN_INFO "rootdir entry found : [%s]\n", rootdir->di_fname));
-					if (!strncmp(rootdir->di_fname, QNX4_BMNAME, sizeof QNX4_BMNAME)) {
+					if (!strcmp(rootdir->di_fname,
+						    QNX4_BMNAME)) {
 						found = 1;
 						qnx4_sb(sb)->BitMap = kmalloc( sizeof( struct qnx4_inode_entry ), GFP_KERNEL );
 						if (!qnx4_sb(sb)->BitMap) {


