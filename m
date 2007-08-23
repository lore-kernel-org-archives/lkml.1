Return-Path: <linux-kernel-owner+w=401wt.eu-S1765871AbXHWXqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765871AbXHWXqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 19:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760509AbXHWXqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 19:46:42 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:58302 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758742AbXHWXqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 19:46:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:resent-from:resent-to:resent-date:resent-message-id:message-id:in-reply-to:references:from:date:subject:to:cc:mime-version:content-transfer-encoding:content-disposition;
        b=iT4WBFmT3IUrkFACkNm027ndzQe1bzP23IYkbUPd4FMbpaZ6ACyn/X962Gtr4fjiWpnSq3by1WCLD7u05jjIwz9BCEZXns0mZfPeKDp3USJoMOeflFpj8Buz6WGpoQnb4GlHB5sHWKIg8UsuMc6ZFc2oPP21JnhkjYJTLh6Ec3M=
Message-Id: <9c32c87607b7e38a8bdfd5a9e536d42f259c7f64.1187912217.git.jesper.juhl@gmail.com>
In-Reply-To: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
From: Jesper Juhl <jesper.juhl@gmail.com>
Date: Fri, 24 Aug 2007 01:43:49 +0200
Subject: [PATCH 03/30] um: Don't unnecessarily cast allocation return value in ubd_kern.c
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Jeff Dike <jdike@karaya.com>, user-mode-linux-devel@lists.sourceforge.net,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

vmalloc() returns a void pointer, so casting to (void *) is pretty pointless.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---
 arch/um/drivers/ubd_kern.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 0eabe73..25b248a 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -615,7 +615,7 @@ static int ubd_open_dev(struct ubd *ubd_dev)
 		blk_queue_max_sectors(ubd_dev->queue, 8 * sizeof(long));
 
 		err = -ENOMEM;
-		ubd_dev->cow.bitmap = (void *) vmalloc(ubd_dev->cow.bitmap_len);
+		ubd_dev->cow.bitmap = vmalloc(ubd_dev->cow.bitmap_len);
 		if(ubd_dev->cow.bitmap == NULL){
 			printk(KERN_ERR "Failed to vmalloc COW bitmap\n");
 			goto error;
-- 
1.5.2.2

