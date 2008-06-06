Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbYFFJW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbYFFJW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 05:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbYFFJWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 05:22:20 -0400
Received: from gw.goop.org ([64.81.55.164]:59227 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303AbYFFJWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 05:22:20 -0400
Message-ID: <484901A3.3040401@goop.org>
Date: Fri, 06 Jun 2008 10:21:39 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>, Stable Kernel <stable@kernel.org>,
       x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH UPDATED] x86: set PAE PHYSICAL_MASK_SHIFT to 44 bits.
References: <4848046A.5060006@goop.org> <484823BD.76E4.0078.0@novell.com>
In-Reply-To: <484823BD.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a 64-bit x86 processor runs in 32-bit PAE mode, a pte can
potentially have the same number of physical address bits as the
64-bit host ("Enhanced Legacy PAE Paging").  This means, in theory,
we could have up to 52 bits of physical address in a pte.

The 32-bit kernel uses a 32-bit unsigned long to represent a pfn.
This means that it can only represent physical addresses up to 32+12=44
bits wide.  Rather than widening pfns everywhere, just set 2^44 as the
Linux x86_32-PAE architectural limit for physical address size.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Jan Beulich <jbeulich@novell.com>
---
 include/asm-x86/page_32.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

===================================================================
--- a/include/asm-x86/page_32.h
+++ b/include/asm-x86/page_32.h
@@ -22,7 +22,8 @@
 
 
 #ifdef CONFIG_X86_PAE
-#define __PHYSICAL_MASK_SHIFT	36
+/* 44=32+12, the limit we can fit into an unsigned long pfn */
+#define __PHYSICAL_MASK_SHIFT	44
 #define __VIRTUAL_MASK_SHIFT	32
 #define PAGETABLE_LEVELS	3
 


