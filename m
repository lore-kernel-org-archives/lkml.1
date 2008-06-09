Return-Path: <linux-kernel-owner+w=401wt.eu-S1760498AbYFILla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760498AbYFILla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 07:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759591AbYFILlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 07:41:20 -0400
Received: from anchor-post-34.mail.demon.net ([194.217.242.92]:2599 "EHLO
	anchor-post-34.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754078AbYFILlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 07:41:20 -0400
Subject: [patch] dm: reorder dm_io to remove padding on 64 bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: dm-devel@redhat.com
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 09 Jun 2008 12:41:15 +0100
Message-Id: <1213011675.2967.5.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

shrinks size from 40 -> 32 allowing more objects/slab
    
Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

---

This change looks safe AFAICT, but I have not tested it other than
compiling it.
Compiled on 2.6.26-rc5 AMD64.
HTH
Richard


diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 372369b..efe9690 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -37,8 +37,8 @@ static DEFINE_SPINLOCK(_minor_lock);
 struct dm_io {
 	struct mapped_device *md;
 	int error;
-	struct bio *bio;
 	atomic_t io_count;
+	struct bio *bio;
 	unsigned long start_time;
 };
 


