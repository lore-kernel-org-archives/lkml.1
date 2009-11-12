Return-Path: <linux-kernel-owner+w=401wt.eu-S1752701AbZKLKOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbZKLKOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 05:14:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbZKLKN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 05:13:59 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:60670 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbZKLKN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 05:13:58 -0500
Date: Thu, 12 Nov 2009 11:14:02 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Anders Larsen <al@alarsen.net>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/4] fs/qnx4: decrement sizeof size in strncmp
In-Reply-To: <1258017918l.26867l.0l@i-dmzi_al.realan.de>
Message-ID: <Pine.LNX.4.64.0911121113190.19166@ask.diku.dk>
References: <Pine.LNX.4.64.0911120849260.16627@ask.diku.dk>
 <1258017918l.26867l.0l@i-dmzi_al.realan.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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
