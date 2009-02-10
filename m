Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbZBJWcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbZBJWcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 17:32:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbZBJWco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 17:32:44 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:51299 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbZBJWcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 17:32:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=W1UB3Txc7j3b5IgSNGqTydrz2D0ynuFvLUsqTQfkKeQQiYoEcXGL0V7uF5zA0qsPIJ
         W5MTJiOYz/VRwsdo/RYkQyF3ELpp2wttLuIQiuYjY1UBeExoF9aLuh6iIjmpUtA7R5Hc
         tb2sMeDLh93EOaN8UO4JMmLsSeCuKkftyJ5lM=
MIME-Version: 1.0
Date: Tue, 10 Feb 2009 22:32:41 +0000
Message-ID: <c6b1100b0902101432m67f90a62k1c41c9fbc561676f@mail.gmail.com>
Subject: Fix build failure caused by 5a6fe125950676015f5108fb71b2a67441755003 
	[was Re: 2.6.29-rc4-git2 build failure]
From: Chris Clayton <chris2553@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Earlier this evening I reported a build failure with the latest -git
I've looked more closely at this and I think I've figured out the fix.

Commit 5a6fe125950676015f5108fb71b2a67441755003 missed updating a
macro in include/linux/hugetlb.h. Do that now.

Signed-off-by: Chris Clayton <chris2553@googlemail.com>

--- linux-2.6/include/linux/hugetlb.h.orig	2009-02-10 22:22:04.000000000 +0000
+++ linux-2.6/include/linux/hugetlb.h	2009-02-10 22:18:25.000000000 +0000
@@ -161,7 +161,7 @@

 #define is_file_hugepages(file)		0
 #define set_file_hugepages(file)	BUG()
-#define hugetlb_file_setup(name,size)	ERR_PTR(-ENOSYS)
+#define hugetlb_file_setup(name,size,int)	ERR_PTR(-ENOSYS)

 #endif /* !CONFIG_HUGETLBFS */



2009/2/10 Chris Clayton <chris2553@googlemail.com>:
> 2.6.29-rc4-git2 build fails after "git pull" a few minutes ago
>
>  CC      ipc/shm.o
> ipc/shm.c:371:49: error: macro "hugetlb_file_setup" passed 3
> arguments, but takes just 2
> ipc/shm.c: In function 'newseg':
> ipc/shm.c:371: error: 'hugetlb_file_setup' undeclared (first use in
> this function)
> ipc/shm.c:371: error: (Each undeclared identifier is reported only once
> ipc/shm.c:371: error: for each function it appears in.)
> make[1]: *** [ipc/shm.o] Error 1
> make: *** [ipc] Error 2
>
> Happy to test patches
>
> Chris
>
> --
> In a world without walls and fences, who needs windows and gates?
>



-- 
In a world without walls and fences, who needs windows and gates?
