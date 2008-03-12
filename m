Return-Path: <linux-kernel-owner+w=401wt.eu-S1752734AbYCLANi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbYCLANi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 20:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbYCLANa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 20:13:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbYCLAN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 20:13:29 -0400
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] genhd must_check warning fix
X-Fcc: ~/Mail/linus
X-Zippy-Says: NEWARK has been REZONED!!  DES MOINES has been REZONED!!
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <20080312001317.D68A526F991@magilla.localdomain>
Date: Tue, 11 Mar 2008 17:13:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes:

	block/genhd.c:361: warning: ignoring return value of ‘class_register’, declared with attribute warn_unused_result

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 block/genhd.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index c44527d..00da521 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -360,7 +360,9 @@ static struct kobject *base_probe(dev_t devt, int *part, void *data)
 
 static int __init genhd_device_init(void)
 {
-	class_register(&block_class);
+	int error = class_register(&block_class);
+	if (unlikely(error))
+		return error;
 	bdev_map = kobj_map_init(base_probe, &block_class_lock);
 	blk_dev_init();
 
