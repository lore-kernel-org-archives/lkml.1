Return-Path: <linux-kernel-owner+w=401wt.eu-S1762970AbYFGQSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762970AbYFGQSz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 12:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759487AbYFGQSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 12:18:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758740AbYFGQSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 12:18:48 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix an incompatible pointer type warning on x86_64
	compilations
To: tglx@linutronix.de
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Sat, 07 Jun 2008 17:18:40 +0100
Message-ID: <20080607161840.4803.48478.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix an incompatible pointer type warning on x86_64 compilations.
early_memtest() is passing a u64* to find_e820_area_size() which is expecting
an unsigned long.  Change t_start and t_size to unsigned long as those are
also 64-bit types on x88_64.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/x86/mm/init_64.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 156e6d7..998a06e 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -506,7 +506,7 @@ early_param("memtest", parse_memtest);
 
 static void __init early_memtest(unsigned long start, unsigned long end)
 {
-	u64 t_start, t_size;
+	unsigned long t_start, t_size;
 	unsigned pattern;
 
 	if (!memtest_pattern)
@@ -525,7 +525,7 @@ static void __init early_memtest(unsigned long start, unsigned long end)
 			if (t_start + t_size > end)
 				t_size = end - t_start;
 
-			printk(KERN_CONT "\n  %016llx - %016llx pattern %d",
+			printk(KERN_CONT "\n  %016lx - %016lx pattern %d",
 				t_start, t_start + t_size, pattern);
 
 			memtest(t_start, t_size, pattern);

