Return-Path: <linux-kernel-owner+w=401wt.eu-S965275AbXCFQbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965275AbXCFQbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 11:31:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965277AbXCFQbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 11:31:48 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:51788 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965275AbXCFQbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 11:31:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=quEyIocB31JGgEVtxAqpsqhHexOhHkye55csnlhVBh1mdm/RYfsTmI/6qhXuz33YvIs7AFWASxeXHvWbwZoJybEmkJvuKX60DTg3PSLPRodfm5ZIebiI5FNC/ppp4cYmL2qyCp3Ut3D2OdgdRhueF1rG10/FnyOiA0xvobo7kMU=
Message-ID: <9c21eeae0703060831k1a99bd13k1bf81afaabb6f1af@mail.gmail.com>
Date: Tue, 6 Mar 2007 08:31:45 -0800
From: "David Brown" <dmlb2000@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH] remove availability for PAGE_SIZE and friends (i386)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After a bit of discussion I found out that PAGE_SIZE really shouldn't
be available for use at all by userspace. So here's a patch to move
the __KERNEL__ define to include PAGE_SIZE and friends for i386.

Thanks,
- David Brown

diff --git a/include/asm-i386/page.h b/include/asm-i386/page.h
index 7b19f45..2f686d5 100644
--- a/include/asm-i386/page.h
+++ b/include/asm-i386/page.h
@@ -1,6 +1,8 @@
 #ifndef _I386_PAGE_H
 #define _I386_PAGE_H

+#define __KERNEL__
+
 /* PAGE_SHIFT determines the page size */
 #define PAGE_SHIFT     12
 #define PAGE_SIZE      (1UL << PAGE_SHIFT)
@@ -9,7 +11,6 @@
 #define LARGE_PAGE_MASK (~(LARGE_PAGE_SIZE-1))
 #define LARGE_PAGE_SIZE (1UL << PMD_SHIFT)

-#ifdef __KERNEL__
 #ifndef __ASSEMBLY__
