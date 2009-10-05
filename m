Return-Path: <linux-kernel-owner+w=401wt.eu-S1754366AbZJESIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbZJESIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 14:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbZJESII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 14:08:08 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:40419 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbZJESIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 14:08:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Of9vwY6ENcq8G/h1ku06n6+YcOxFwfzeftBSNPH2AC/V4iZ2CNWvSXEbAbJt84Su53
         ybXouM7zIzfS0bcrG8zu14Xr9d/blRJbyVlSLLdPAKRvGDTW9Ag6Ul+rWh8iwvn8Es9r
         myHxe2SUXL4Jpypi/yu/HjNnHSkYDlQN0HFYQ=
Subject: [PATCH 1/1, revised] fs: added KERN-DEBUG flag to dprintk macro
From: Pete <greg.petr@gmail.com>
To: kernel-janitors@vger.kernel.org, trivial@kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Joe Perches <joe@perches.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 05 Oct 2009 23:35:15 +0530
Message-Id: <1254765915.5279.77.camel@linux-k65f.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Greg Petr <greg.petr@gmail.com>

Hi, 

The following is a trivial patch which adds KERN_DEBUG flag to the
dprintk macro. Made this a more generalized version. 


--- linux-2.6/fs/aio.c	2009-10-05 14:46:11.000000000 +0530
+++ linux-2.6.test/fs/aio.c	2009-10-05 23:30:26.000000000 +0530
@@ -37,7 +37,7 @@
 #include <asm/uaccess.h>
 
 #if DEBUG > 1
-#define dprintk		printk
+#define dprintk(x...)		printk(KERN_DEBUG x)
 #else
 #define dprintk(x...)	do { ; } while (0)
 #endif
@@ -530,7 +530,7 @@ static void aio_fput_routine(struct work
  */
 static int __aio_put_req(struct kioctx *ctx, struct kiocb *req)
 {
-	dprintk(KERN_DEBUG "aio_put(%p): f_count=%ld\n",
+	dprintk("aio_put(%p): f_count=%ld\n",
 		req, atomic_long_read(&req->ki_filp->f_count));
 
 	assert_spin_locked(&ctx->ctx_lock);


