Return-Path: <linux-kernel-owner+w=401wt.eu-S1757544AbXJ0SrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbXJ0SrO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 14:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbXJ0SrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 14:47:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33493 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbXJ0Sq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 14:46:59 -0400
Date: Sat, 27 Oct 2007 19:46:58 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] cirrusfb nonsense
Message-ID: <20071027184658.GR8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	(pointer > 0) is deeply weird; (pointer >= 0) is even dumber...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/video/cirrusfb.c b/drivers/video/cirrusfb.c
index f99cb77..f7e2d5a 100644
--- a/drivers/video/cirrusfb.c
+++ b/drivers/video/cirrusfb.c
@@ -2509,8 +2509,7 @@ static int cirrusfb_zorro_register(struct zorro_dev *z,
 	cinfo = info->par;
 	cinfo->btype = btype;
 
-	assert(z > 0);
-	assert(z2 >= 0);
+	assert(z);
 	assert(btype != BT_NONE);
 
 	cinfo->zdev = z;
