Return-Path: <linux-kernel-owner+w=401wt.eu-S1752854AbXCZPX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbXCZPX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 11:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbXCZPX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 11:23:59 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:59340 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbXCZPX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 11:23:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=kQ7FSlnEBQkJoPsTzZsHD1qdhbjqHUyscFjYTtinHoqMRIorBfGA3OaybvNgu7aHBHPVXP2WpBDiOUq2Cj7337Cj/bM+0t9GZi8npGANLzCtUVjqohB7HRrY8jfdvRgZ9+2pRb/6DY64nOA/lR542WzvDrlgyPiUYMze6SxqXI0=
Message-ID: <ee9e417a0703260823k55c6de8ay715be1db11692355@mail.gmail.com>
Date: Mon, 26 Mar 2007 11:23:56 -0400
From: "Russ Cox" <rsc@swtch.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Add const to pointer qualifiers for __chk_user_ptr and __chk_io_ptr.
Cc: linux-sparse@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 8f676a686572f7bf
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Change prototypes for  __chk_user_ptr and __chk_io_ptr
to take const void* instead of void*, so that code can pass
const void* to them.  (Right now sparse does not warn
about passing const void* to void* functions, but that
is a separate bug that I believe Josh is working on,
and once sparse does check this, the changed prototypes
will be necessary.)

Signed-off-by: Russ Cox <rsc@swtch.com>
Signed-off-by: Josh Triplett <josh@freedesktop.org>

---

 include/linux/compiler.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

e5174dfa73190036ae1086110292594a3ffb3752
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index aca6698..3b6949b 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -15,8 +15,8 @@
 # define __acquire(x)	__context__(x,1)
 # define __release(x)	__context__(x,-1)
 # define __cond_lock(x,c)	((c) ? ({ __acquire(x); 1; }) : 0)
-extern void __chk_user_ptr(void __user *);
-extern void __chk_io_ptr(void __iomem *);
+extern void __chk_user_ptr(const void __user *);
+extern void __chk_io_ptr(const void __iomem *);
 #else
 # define __user
 # define __kernel
-- 
1.1.3
