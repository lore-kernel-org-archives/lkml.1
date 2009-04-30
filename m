Return-Path: <linux-kernel-owner+w=401wt.eu-S1761450AbZD3APR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761450AbZD3APR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 20:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753848AbZD3APB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 20:15:01 -0400
Received: from exprod6ob113.obsmtp.com ([64.18.1.30]:47221 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752347AbZD3APA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 20:15:00 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] fs/super.c: fix sparse warning
Date: Wed, 29 Apr 2009 20:14:57 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909016C1B15@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] fs/super.c: fix sparse warning
Thread-Index: AcnJKLHdVgSQngg4Q4OJHbTv97AxZQ==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 30 Apr 2009 00:14:58.0493 (UTC) FILETIME=[B25AA6D0:01C9C928]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse reports the following in fs/super.c:

  warning: Using plain integer as NULL pointer

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Subrata Modak <subrata@linux.vnet.ibm.com>

---

diff --git a/fs/super.c b/fs/super.c
index 786fe7d..14e59bc 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -897,7 +897,7 @@ void kill_block_super(struct super_block *sb)
 	struct block_device *bdev = sb->s_bdev;
 	fmode_t mode = sb->s_mode;
 
-	bdev->bd_super = 0;
+	bdev->bd_super = NULL;
 	generic_shutdown_super(sb);
 	sync_blockdev(bdev);
 	close_bdev_exclusive(bdev, mode); 
