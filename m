Return-Path: <linux-kernel-owner+w=401wt.eu-S1761523AbYCUUM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761523AbYCUUM7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 16:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756267AbYCUUMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 16:12:50 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:25556 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437AbYCUUMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 16:12:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=QcwrA+668fnTf7WrIvwFe5ATTsEvrLX1OXES3edv/gWPqhE3e+Vyj1lUEHSN2fgcnUXyao92smTqWDcy2lbv3Z59bsUWSv5wzF4qTJTDeb+aDqYAJIAeelqumTvFzQIX+fR/r6STNMXCBqjggmmK5ZAb8ZItvJxLz8CeO2J7KEg=
Date: Fri, 21 Mar 2008 23:12:14 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: relocate_kernel - use predefined PAGE_SIZE instead of
	own alias
Message-ID: <20080321201214.GA9424@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does clean up relocate_kernel_(32|64).S a bit by getting rid
of local PAGE_ALIGNED macro. We should use well-known PAGE_SIZE instead

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

 relocate_kernel_32.S |    3 +--
 relocate_kernel_64.S |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/relocate_kernel_32.S
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/relocate_kernel_32.S	2008-03-15 11:24:51.000000000 +0300
+++ linux-2.6.git/arch/x86/kernel/relocate_kernel_32.S	2008-03-21 23:00:10.000000000 +0300
@@ -15,12 +15,11 @@
  */
 
 #define PTR(x) (x << 2)
-#define PAGE_ALIGNED (1 << PAGE_SHIFT)
 #define PAGE_ATTR 0x63 /* _PAGE_PRESENT|_PAGE_RW|_PAGE_ACCESSED|_PAGE_DIRTY */
 #define PAE_PGD_ATTR 0x01 /* _PAGE_PRESENT */
 
 	.text
-	.align PAGE_ALIGNED
+	.align PAGE_SIZE
 	.globl relocate_kernel
 relocate_kernel:
 	movl	8(%esp), %ebp /* list of pages */
Index: linux-2.6.git/arch/x86/kernel/relocate_kernel_64.S
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/relocate_kernel_64.S	2008-03-15 11:24:51.000000000 +0300
+++ linux-2.6.git/arch/x86/kernel/relocate_kernel_64.S	2008-03-21 22:59:08.000000000 +0300
@@ -15,11 +15,10 @@
  */
 
 #define PTR(x) (x << 3)
-#define PAGE_ALIGNED (1 << PAGE_SHIFT)
 #define PAGE_ATTR 0x63 /* _PAGE_PRESENT|_PAGE_RW|_PAGE_ACCESSED|_PAGE_DIRTY */
 
 	.text
-	.align PAGE_ALIGNED
+	.align PAGE_SIZE
 	.code64
 	.globl relocate_kernel
 relocate_kernel:
