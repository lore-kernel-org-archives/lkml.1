Return-Path: <linux-kernel-owner+w=401wt.eu-S1758017AbZDFOj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbZDFOj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 10:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755549AbZDFOjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 10:39:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58279 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755329AbZDFOjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 10:39:18 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Fix compile breakage
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
       David Howells <dhowells@redhat.com>
Date: Mon, 06 Apr 2009 15:36:04 +0100
Message-ID: <20090406143604.16864.95018.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>

This patch fixes the follwing build error caused by
commit 7ca43e7564679604d86e9ed834e7bbcffd8a4a3f
(mm: use debug_kmap_atomic):

<--  snip  -->

...
  AS      arch/frv/mm/tlb-miss.o
...
In file included from
arch/frv/mm/tlb-miss.S:13:
...
Assembler messages:
include/asm-generic/ioctl.h:73:
Error: unrecognized instruction `extern unsigned int __invalid_size_argument_for_IO...'
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/mm/tlb-miss.S |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)


diff --git a/arch/frv/mm/tlb-miss.S b/arch/frv/mm/tlb-miss.S
index 0764348..7f392bc 100644
--- a/arch/frv/mm/tlb-miss.S
+++ b/arch/frv/mm/tlb-miss.S
@@ -13,7 +13,6 @@
 #include <linux/linkage.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/highmem.h>
 #include <asm/spr-regs.h>
 
 	.section	.text.tlbmiss

