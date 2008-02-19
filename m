Return-Path: <linux-kernel-owner+w=401wt.eu-S1759339AbYBSTQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759339AbYBSTQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbYBSTQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:16:09 -0500
Received: from smtp2.sssup.it ([193.205.80.100]:49707 "EHLO smpt2.sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754644AbYBSTQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:16:08 -0500
Message-ID: <47BB2AE4.1000206@gandalf.sssup.it>
Date: Tue, 19 Feb 2008 20:15:48 +0100
From: michael <trimarchi@gandalf.sssup.it>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-mtd@lists.infradead.org
Subject: [PATCH] Add write verify on dataflash.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the write verification buffer to the dataflash. The
mtd_dataflash has the CONFIG_DATAFLASH_WRITE_VERIFY so
is better a change to Kconfig.

Signed-off-by: Michael Trimarchi <trimarchimichael@yahoo.it>
---
 fs/jffs2/wbuf.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/jffs2/wbuf.c b/fs/jffs2/wbuf.c
index d1d4f27..ba49f19 100644
--- a/fs/jffs2/wbuf.c
+++ b/fs/jffs2/wbuf.c
@@ -1236,12 +1236,24 @@ int jffs2_dataflash_setup(struct jffs2_sb_info *c) {
        if (!c->wbuf)
                return -ENOMEM;

+#ifdef CONFIG_JFFS2_FS_WBUF_VERIFY
+       c->wbuf_verify = kmalloc(c->wbuf_pagesize, GFP_KERNEL);
+       if (!c->wbuf_verify) {
+               kfree(c->oobbuf);
+               kfree(c->wbuf);
+               return -ENOMEM;
+       }
+#endif
+
        printk(KERN_INFO "JFFS2 write-buffering enabled buffer (%d) 
erasesize (%d)\n", c->wbuf_pagesize, c->sector_size);

        return 0;
 }

 void jffs2_dataflash_cleanup(struct jffs2_sb_info *c) {
+#ifdef CONFIG_JFFS2_FS_WBUF_VERIFY
+       kfree(c->wbuf_verify);
+#endif
        kfree(c->wbuf);
 }

--
1.5.2.1.174.gcd03

