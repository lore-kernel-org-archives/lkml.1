Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbYGRPFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbYGRPFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 11:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbYGRPFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 11:05:42 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:48894 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbYGRPFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 11:05:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Y+FTiPL7zWirf3190UzSkSpbGVySMXn5luzf54YppQKHLuv+Ez0LPvuHeoSw/W13Ma
         Dxtfa6gnOG0YfG0djIu3Z5PR03MFnWRm6YRLjxSybYfAgNwvW2xYdgZVSgKP/NytaGL/
         wt6xWz8omj/leUbCmpi+1pMQ9kesxrXlWZxhI=
Date: Fri, 18 Jul 2008 16:04:10 +0100
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: ebiederm@xmission.com, kexec@lists.infradead.org
Subject: [Patch] kexec: remove redundant if-else
Message-ID: <20080718150410.GB26261@hack.voiplan.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These if-else's can be removed.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: ebiederm@xmission.com

---
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 1c5fcac..ea6fa9b 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -203,13 +203,11 @@ static int do_kimage_alloc(struct kimage **rimage, unsigned long entry,
 			goto out;
 	}
 
-	result = 0;
-out:
-	if (result == 0)
-		*rimage = image;
-	else
-		kfree(image);
+	*rimage = image;
+	return 0;
 
+out:
+	kfree(image);
 	return result;
 
 }
@@ -242,13 +240,11 @@ static int kimage_normal_alloc(struct kimage **rimage, unsigned long entry,
 		goto out;
 	}
 
-	result = 0;
- out:
-	if (result == 0)
-		*rimage = image;
-	else
-		kfree(image);
+	*rimage = image;
+	return 0;
 
+ out:
+	kfree(image);
 	return result;
 }
 
@@ -311,13 +307,11 @@ static int kimage_crash_alloc(struct kimage **rimage, unsigned long entry,
 		goto out;
 	}
 
-	result = 0;
-out:
-	if (result == 0)
-		*rimage = image;
-	else
-		kfree(image);
+	*rimage = image;
+	return 0;
 
+out:
+	kfree(image);
 	return result;
 }
 
