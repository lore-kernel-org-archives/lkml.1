Return-Path: <linux-kernel-owner+w=401wt.eu-S1759393AbXJ2Qnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393AbXJ2Qnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 12:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbXJ2Qnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 12:43:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979AbXJ2Qni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 12:43:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Permit the memory to be located elsewhere in NOMMU mode
	[try #2]
To: torvalds@osdl.org, akpm@osdl.org, rpjday@crashcourse.ca
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Mon, 29 Oct 2007 16:43:32 +0000
Message-ID: <20071029164332.24646.28739.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Permit the memory to be located somewhere other than address 0xC0000000 in
NOMMU mode.  The configuration options are already present, it just requires
wiring up in the linker script.

Note that only a limited set of locations of runtime addresses are available
because of the way the CPU protection registers work.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/Kconfig              |    9 +++++++++
 arch/frv/kernel/vmlinux.lds.S |    2 +-
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index 43153e7..a4ee80b 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -138,6 +138,15 @@ config UCPAGE_OFFSET_C0000000
 
 endchoice
 
+config PAGE_OFFSET
+	hex
+	default 0x20000000 if UCPAGE_OFFSET_20000000
+	default 0x40000000 if UCPAGE_OFFSET_40000000
+	default 0x60000000 if UCPAGE_OFFSET_60000000
+	default 0x80000000 if UCPAGE_OFFSET_80000000
+	default 0xA0000000 if UCPAGE_OFFSET_A0000000
+	default 0xC0000000
+
 config PROTECT_KERNEL
 	bool "Protect core kernel against userspace"
 	depends on !MMU
diff --git a/arch/frv/kernel/vmlinux.lds.S b/arch/frv/kernel/vmlinux.lds.S
index 3b71e0c..a62b245 100644
--- a/arch/frv/kernel/vmlinux.lds.S
+++ b/arch/frv/kernel/vmlinux.lds.S
@@ -13,7 +13,7 @@ ENTRY(_start)
 
 jiffies = jiffies_64 + 4;
 
-__page_offset = 0xc0000000;		/* start of area covered by struct pages */
+__page_offset = CONFIG_PAGE_OFFSET;	/* start of area covered by struct pages */
 __kernel_image_start = __page_offset;	/* address at which kernel image resides */
 
 SECTIONS

