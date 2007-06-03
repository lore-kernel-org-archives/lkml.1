Return-Path: <linux-kernel-owner+w=401wt.eu-S1752537AbXFDACr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbXFDACr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 20:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750750AbXFDACk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 20:02:40 -0400
Received: from host-69-39-86-10.a2webhosting.com ([69.39.86.10]:35336 "EHLO
	a2s21.a2hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbXFDACj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 20:02:39 -0400
X-Greylist: delayed 3435 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Jun 2007 20:02:39 EDT
Message-ID: <466348F7.9030904@banksresearch.com>
Date: Sun, 03 Jun 2007 19:04:23 -0400
From: Wyatt Banks <wyatt@banksresearch.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: zippel@linux-m68k.org, linux-kernel@vger.kernel.org
Subject: [PATCH] HFSPlus: change kmalloc/memset to kzalloc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-A2hosting-MailScanner-Information: Please contact the ISP for more information
X-A2hosting-MailScanner: Found to be clean
X-A2hosting-MailScanner-SpamCheck: 
X-A2hosting-MailScanner-From: wyatt@banksresearch.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - a2s21.a2hosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - banksresearch.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Wyatt Banks <wyatt@banksresearch.com>

Removed kmalloc and memset in favor of kzalloc.

Signed-off-by:	Wyatt Banks <wyatt@banksresearch.com>

---

Patched against 2.6.21.3

To explain the HFSPLUS_SB() macro in the removed memset call:

hfsplus_fs.h:#define HFSPLUS_SB(super)  (*(struct hfsplus_sb_info *)(super)->s_fs_info)


--- linux-2.6.21.3/fs/hfsplus/super.c	2007-05-24 17:22:47.000000000 -0400
+++ linux-2.6.21.3-devel/fs/hfsplus/super.c	2007-06-02 12:29:33.000000000 -0400
@@ -283,11 +283,10 @@ static int hfsplus_fill_super(struct sup
	struct nls_table *nls = NULL;
	int err = -EINVAL;

-	sbi = kmalloc(sizeof(struct hfsplus_sb_info), GFP_KERNEL);
+	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
	if (!sbi)
		return -ENOMEM;

-	memset(sbi, 0, sizeof(HFSPLUS_SB(sb)));
	sb->s_fs_info = sbi;
	INIT_HLIST_HEAD(&sbi->rsrc_inodes);
	hfsplus_fill_defaults(sbi);
