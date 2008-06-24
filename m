Return-Path: <linux-kernel-owner+w=401wt.eu-S1761719AbYFXQqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761719AbYFXQqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 12:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760419AbYFXQqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 12:46:19 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:40612 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757886AbYFXQqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 12:46:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=KU1QrWROWpckQe1huJE3Eo7Z/J4173mYPMnDZ+yJElYObj3PT6z8kiYUhkGDeIKQTK
         BewpHp1ZjsK/by0GDTVXftHZmHi/BKE4Ivm89Aw+6+xCwawmgzX81ArrdJZ4HYhq1+7J
         ByRsmop9mKkA2tMjA1X3JjVhxCHJaIy1p4ueM=
Date: Tue, 24 Jun 2008 17:42:40 +0100
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: kexec@lists.infradead.org, ebiederm@xmission.com
Subject: [Patch] kernel/kexec.c: make 'kimage_terminate' void
Message-ID: <20080624164240.GF10512@hack.voiplan.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since kimage_terminate() always returns 0, make it void.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Eric Biederman <ebiederm@xmission.com>

---
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 1c5fcac..6db42ff 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -589,14 +589,12 @@ static void kimage_free_extra_pages(struct kimage *image)
 	kimage_free_page_list(&image->unuseable_pages);
 
 }
-static int kimage_terminate(struct kimage *image)
+static void kimage_terminate(struct kimage *image)
 {
 	if (*image->entry != 0)
 		image->entry++;
 
 	*image->entry = IND_DONE;
-
-	return 0;
 }
 
 #define for_each_kimage_entry(image, ptr, entry) \
@@ -997,9 +995,7 @@ asmlinkage long sys_kexec_load(unsigned long entry, unsigned long nr_segments,
 			if (result)
 				goto out;
 		}
-		result = kimage_terminate(image);
-		if (result)
-			goto out;
+		kimage_terminate(image);
 	}
 	/* Install the new kernel, and  Uninstall the old */
 	image = xchg(dest_image, image);
