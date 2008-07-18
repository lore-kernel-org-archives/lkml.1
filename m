Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbYGRG1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbYGRG1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 02:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbYGRG1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 02:27:37 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:6734 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbYGRG1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 02:27:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=m1sRPiSIUnUA8r7kHIhF0TNc2dc7LRJBLQlGJ5bVuPiUVHbZpP/iCxttvcY5o0NLSh
         2ukscqufMeyQR4hGxkm/ePR01ikaqJwm9Tx3IRVBR8BWQ7Jt8ejCjfoYehFsq6W+EHxT
         hG+QE08zTBXYtPrvcttw+1QrjPec9FODyHcew=
Message-ID: <804dabb00807172327m4509d134j6d30222759d8cde4@mail.gmail.com>
Date: Fri, 18 Jul 2008 14:27:34 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Error during compilation of MMU notifier v18 patch
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry if posted wrongly.   I downloaded the latest MMU notifier patch:

http://www.kernel.org/pub/linux/kernel/people/andrea/patches/v2.6/2.6.26-rc7/mmu-notifier-v18/

And applied it to my rc7 git checkout.

Outcome is all "succeeded" message.

But during compilation, I got the following errors:

  CC      mm/filemap_xip.o
mm/filemap_xip.c: In function '__xip_unmap':
mm/filemap_xip.c:197: error: implicit declaration of function
'mmu_notifier_invalidate_page'
make[1]: *** [mm/filemap_xip.o] Error 1

Applying the following patch:

/download1/2.6.26-rc7>diff -Nurp ../rc7/mm/filemap_xip.c mm/filemap_xip.c
--- ../rc7/mm/filemap_xip.c     2008-07-18 14:15:21.000000000 +0800
+++ mm/filemap_xip.c    2008-07-18 14:35:26.000000000 +0800
@@ -14,6 +14,7 @@
 #include <linux/uio.h>
 #include <linux/rmap.h>
 #include <linux/sched.h>
+#include <linux/mmu_notifier.h>
 #include <asm/tlbflush.h>
 #include <asm/io.h>

Corrected the error.

-- 
Regards,
Peter Teoh
