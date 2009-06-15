Return-Path: <linux-kernel-owner+w=401wt.eu-S1763720AbZFOP7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763720AbZFOP7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbZFOP7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:59:30 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:56306 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbZFOP7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:59:30 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [RFC] Load cache_aligned sections, cache aligned (VIA, some Intel, others?)
Date: Mon, 15 Jun 2009 10:59:21 -0500
User-Agent: KMail/1.9.9
Cc: Harald Welte <HaraldWelte@viatech.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906151059.25242.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The expected size of the processor cache line size is set
in the Kbuild menu by selection of the processor (sort-of).

How about telling the loader to cache-line align the cache_aligned sections?
This define comes in via (no pun intended): arch/x86/include/asm/cache.h

diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index 62ad500..26f68a5 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -82,7 +82,7 @@ SECTIONS
        *(.data.idt)
   }

-  . = ALIGN(32);
+  . = ALIGN(L1_CACHE_BYTES);
   .data.cacheline_aligned : AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET) {
        *(.data.cacheline_aligned)
   }

Mike
