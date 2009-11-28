Return-Path: <linux-kernel-owner+w=401wt.eu-S1753824AbZK1Cmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbZK1Cmr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 21:42:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbZK1Cmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 21:42:46 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:63240 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbZK1Cmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 21:42:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=p+A3CvTo/3J0POhMpdQf+aniL/vv+incwKf71v4uesDTBCW4hFxsSWPkb6WZ6gY3q0
         9ty7Y/dVJwKEqTwo+u47WpwvQfBYj2xdsXQTdOOqCq7od6JRtZMPizZIA4sFmjumFAr9
         3Qmhf4NbSi/cPl//mBr6x8AeipvODnVJdvxzo=
Date: Sat, 28 Nov 2009 10:47:03 +0800
From: "Liuweni" <qingshenlwy@gmail.com>
To: "linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: I cannot find the "linux" definition in arm 
Message-ID: <200911281047004065077@gmail.com>
X-mailer: Foxmail 6, 15, 201, 22 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all,
    the s3c2410_defconfig cannot compile with the SEGMENT_SIZE is missing in the s/binfmt_aout.c.
In the line 270 fs/binfmt_aout.c, the function will call a macro "N_DATADDR". The N_DATADDR is defined as  the following, in the include/linux/a.out.h
------
#ifndef N_DATADDR
#define N_DATADDR(x) \
    (N_MAGIC(x)==OMAGIC? (_N_TXTENDADDR(x)) \
     : (_N_SEGMENT_ROUND (_N_TXTENDADDR(x))))
#endif                   
------
And  the definition of _N_SEGMENT_ROUND(x) is ALIGN(x, SEGMENT_SIZE).
Then, there is a macro SEGMENT_SIZE.

I search the definition of SEGMENT_SIZE, it's only in the include/linux/a.out.h
Maybe the SEGMENT is defined as 
---
#ifdef linux
#ifdef __KERNEL__
#include <asm/page.h>
#else
#include <unistd.h>
#endif
#if defined(__i386__) || defined(__mc68000__)
#define SEGMENT_SIZE	1024
#else
#ifndef SEGMENT_SIZE
#ifdef __KERNEL__
#define SEGMENT_SIZE	PAGE_SIZE
#else
#define SEGMENT_SIZE   getpagesize()
#endif
#endif
#endif
#endif
---
But I cannot find the definition of linux. And the SEGMENT_SIZE is not defined.

what should I do? remove binfmt in the arch/arm/Kconfig, change
include/linux/a.out.h, or other ?


BTW, the x86 is OK, but also I cannot find the definition of "linux"
 				
--------------
Best regards,
Liuweni
2009-11-28

