Return-Path: <linux-kernel-owner+w=401wt.eu-S1755053AbYKPXcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbYKPXcf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 18:32:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560AbYKPXc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 18:32:27 -0500
Received: from mail.gmx.net ([213.165.64.20]:47498 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751327AbYKPXc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 18:32:26 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX194UTBTUvx4ldyqSLRLTLqbi24knGKyqzMqxQElDN
	RJa5m0Gwgk68Zc
From: Helge Deller <deller@gmx.de>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, Kyle Mc Martin <kyle@hera.kernel.org>,
       linux-parisc@vger.kernel.org, linux-mm <linux-mm@kvack.org>
Subject: [PATCH, 2.6.28-rc5] unitialized return value in mm/mlock.c: __mlock_vma_pages_range()
Date: Mon, 17 Nov 2008 00:30:57 +0100
User-Agent: KMail/1.9.7
X-Face: &[jmHH-Dw>Aj):"[/t-VasJu+(5eP`/LEckV7V"JV,!nBy[6(/?#8M>x`5xzg/7:FkM.l@=?utf-8?q?=0A=0913?=<&9'nfV3"OkD~P)@j{P2=(uB7J(){:CcrM2jZeA+IBq?FUTp3c8Y{t+k<95mZf~[v"=?utf-8?q?=27=3A=0A=09t?="f6wKtHUPFB&/]Z5^?9~IQs=16R;Pg"NS9JD=DK!ft&4b@=?utf-8?q?S=7E=26q/MfI3=3BqWqlg7Q1=3D=3DjS4=0A=099V5OJkm=24WQ=5Bdc=5E=5FY?=
 =?utf-8?q?=27=5DDvibvMjizUZ=5D+=27Jd4UnM?=><yrT}Rw(
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811170030.58246.deller@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix an unitialized return value when compiling on parisc (with CONFIG_UNEVICTABLE_LRU=y):
	mm/mlock.c: In function `__mlock_vma_pages_range':
	mm/mlock.c:165: warning: `ret' might be used uninitialized in this function

Signed-off-by: Helge Deller <deller@gmx.de>

--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -162,7 +162,7 @@ static long __mlock_vma_pages_range(struct vm_area_struct *vma,
 	unsigned long addr = start;
 	struct page *pages[16]; /* 16 gives a reasonable batch */
 	int nr_pages = (end - start) / PAGE_SIZE;
-	int ret;
+	int ret = 0;
 	int gup_flags = 0;
 
 	VM_BUG_ON(start & ~PAGE_MASK);



