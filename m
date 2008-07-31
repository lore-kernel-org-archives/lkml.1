Return-Path: <linux-kernel-owner+w=401wt.eu-S1756374AbYGaQlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374AbYGaQlm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 12:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbYGaQld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 12:41:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123AbYGaQlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 12:41:32 -0400
Message-ID: <4891EB50.20309@redhat.com>
Date: Thu, 31 Jul 2008 12:41:52 -0400
From: Chuck Ebbert <cebbert@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: stable@kernel.org
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [stable] last-minute patch for 2.6.25-stable
Content-Type: multipart/mixed;
 boundary="------------060109080407050709060603"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060109080407050709060603
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I meant to send this yesterday but didn't get to it.


--------------060109080407050709060603
Content-Type: text/plain;
 name="linux-2.6-x86-mm-ioremap-64-bit-resource-on-32-bit-kernel.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="linux-2.6-x86-mm-ioremap-64-bit-resource-on-32-bit-kernel.pa";
 filename*1="tch"

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 25 Mar 2008 07:31:17 +0000 (+0100)
Subject: x86: ioremap of 64-bit resource on 32-bit kernel fix
X-Git-Tag: v2.6.26-rc1~1154^2~109
X-Git-Url: http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Ftorvalds%2Flinux-2.6.git;a=commitdiff_plain;h=756a6c68556600aec9460346332884d891d5beb4

x86: ioremap of 64-bit resource on 32-bit kernel fix

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 7338c5d..c590fd2 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -47,7 +47,7 @@ static inline int phys_addr_valid(unsigned long addr)
 
 int page_is_ram(unsigned long pagenr)
 {
-	unsigned long addr, end;
+	resource_size_t addr, end;
 	int i;
 
 	/*
@@ -120,7 +120,8 @@ int ioremap_change_attr(unsigned long vaddr, unsigned long size,
 static void __iomem *__ioremap(resource_size_t phys_addr, unsigned long size,
 			       enum ioremap_mode mode)
 {
-	unsigned long pfn, offset, last_addr, vaddr;
+	unsigned long pfn, offset, vaddr;
+	resource_size_t last_addr;
 	struct vm_struct *area;
 	pgprot_t prot;
 

--------------060109080407050709060603--
