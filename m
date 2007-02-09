Return-Path: <linux-kernel-owner+w=401wt.eu-S1946536AbXBIPeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946536AbXBIPeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946542AbXBIPeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:34:19 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:2693 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946537AbXBIPeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:34:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=JMDPc2s1s9MpY+Zx7SUIX7R6FwcyvW2Ak35pWkJeKjxZGlYJbj19rWRZmEJnVpa2GjQlyNr1fuEk7x5nVfPTArGkXoGeNdTFmasdn5mfIA8N8Yt+2ynXDUw6CpMO6KLgNhjAguVsD/mn+KfJK4ToQu+oCFv3PKIqY7H6H/yboyk=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk, rmk+lkml@arm.linux.org.uk
Subject: [PATCH 03/34] __initdata cleanup - avr32
Date: Fri, 9 Feb 2007 17:14:42 +0200
User-Agent: KMail/1.9.6
References: <200702091711.34441.alon.barlev@gmail.com>
In-Reply-To: <200702091711.34441.alon.barlev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091714.42910.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial.

**NOT TESTED***

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Bernhard Walle <bwalle@suse.de>

---

diff -urNp linux-2.6.20-rc6-mm3.org/arch/avr32/boards/atstk1000/atstk1002.c linux-2.6.20-rc6-mm3/arch/avr32/boards/atstk1000/atstk1002.c
--- linux-2.6.20-rc6-mm3.org/arch/avr32/boards/atstk1000/atstk1002.c
+++ linux-2.6.20-rc6-mm3/arch/avr32/boards/atstk1000/atstk1002.c
@@ -27,9 +27,9 @@ struct eth_addr {
 	u8 addr[6];
 };
 
-static struct eth_addr __initdata hw_addr[2];
+static struct eth_addr __initdata hw_addr[2] = {{{0}}};
 
-static struct eth_platform_data __initdata eth_data[2];
+static struct eth_platform_data __initdata eth_data[2] = {{0}};
 extern struct lcdc_platform_data atstk1000_fb0_data;
 
 static struct spi_board_info spi_board_info[] __initdata = {
diff -urNp linux-2.6.20-rc6-mm3.org/arch/avr32/boards/atstk1000/setup.c linux-2.6.20-rc6-mm3/arch/avr32/boards/atstk1000/setup.c
--- linux-2.6.20-rc6-mm3.org/arch/avr32/boards/atstk1000/setup.c
+++ linux-2.6.20-rc6-mm3/arch/avr32/boards/atstk1000/setup.c
@@ -17,9 +17,9 @@
 #include <asm/arch/board.h>
 
 /* Initialized by bootloader-specific startup code. */
-struct tag *bootloader_tags __initdata;
+struct tag *bootloader_tags __initdata = NULL;
 
-struct lcdc_platform_data __initdata atstk1000_fb0_data;
+struct lcdc_platform_data __initdata atstk1000_fb0_data = {0};
 
 void __init board_setup_fbmem(unsigned long fbmem_start,
 			      unsigned long fbmem_size)
diff -urNp linux-2.6.20-rc6-mm3.org/arch/avr32/kernel/setup.c linux-2.6.20-rc6-mm3/arch/avr32/kernel/setup.c
--- linux-2.6.20-rc6-mm3.org/arch/avr32/kernel/setup.c
+++ linux-2.6.20-rc6-mm3/arch/avr32/kernel/setup.c
@@ -44,13 +44,13 @@ struct avr32_cpuinfo boot_cpu_data = {
 };
 EXPORT_SYMBOL(boot_cpu_data);
 
-static char __initdata command_line[COMMAND_LINE_SIZE];
+static char __initdata command_line[COMMAND_LINE_SIZE] = "";
 
 /*
  * Should be more than enough, but if you have a _really_ complex
  * setup, you might need to increase the size of this...
  */
-static struct tag_mem_range __initdata mem_range_cache[32];
+static struct tag_mem_range __initdata mem_range_cache[32] = {{0}};
 static unsigned mem_range_next_free;
 
 /*
@@ -87,8 +87,8 @@ static struct resource mem_res[] = {
  * Board-specific code may use these variables to set up platform data
  * for the framebuffer driver if fbmem_size is nonzero.
  */
-static unsigned long __initdata fbmem_start;
-static unsigned long __initdata fbmem_size;
+static unsigned long __initdata fbmem_start = 0l;
+static unsigned long __initdata fbmem_size = 0l;
 
 /*
  * "fbmem=xxx[kKmM]" allocates the specified amount of boot memory for
