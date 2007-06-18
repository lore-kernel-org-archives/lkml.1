Return-Path: <linux-kernel-owner+w=401wt.eu-S1764453AbXFRQCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764453AbXFRQCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 12:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763683AbXFRQB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 12:01:58 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:45713 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763645AbXFRQB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 12:01:57 -0400
X-Originating-Ip: 72.143.66.27
Date: Mon, 18 Jun 2007 11:59:30 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, xfs-masters@oss.sgi.com
Subject: [PATCH] XFS:  Replace remaining memclear_highpage_flush() with
 zero_user_page().
Message-ID: <Pine.LNX.4.64.0706181154090.26616@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  this appears to be the final occurrence of that deprecated call in
the entire tree which suggests that, if you're not concerned about
out-of-tree modules, that definition could also be removed from
include/linux/highmem.h:

static inline void __deprecated memclear_highpage_flush(struct page *page,
                        unsigned int offset, unsigned int size)
{
        zero_user_page(page, offset, size, KM_USER0);
}


diff --git a/fs/xfs/linux-2.6/xfs_lrw.c b/fs/xfs/linux-2.6/xfs_lrw.c
index 86fb671..ed90403 100644
--- a/fs/xfs/linux-2.6/xfs_lrw.c
+++ b/fs/xfs/linux-2.6/xfs_lrw.c
@@ -159,7 +159,7 @@ xfs_iozero(
 		if (status)
 			goto unlock;

-		memclear_highpage_flush(page, offset, bytes);
+		zero_user_page(page, offset, bytes, KM_USER0);

 		status = mapping->a_ops->commit_write(NULL, page, offset,
 							offset + bytes);
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
