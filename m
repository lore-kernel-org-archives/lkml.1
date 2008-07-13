Return-Path: <linux-kernel-owner+w=401wt.eu-S1755671AbYGMSUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671AbYGMSUw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 14:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754771AbYGMSUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 14:20:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:40636 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbYGMSUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 14:20:34 -0400
Date: Sun, 13 Jul 2008 11:17:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.25.11
Message-ID: <20080713181733.GB450@kroah.com>
References: <20080713181412.GA450@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080713181412.GA450@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index e26eb7d..186bd6f 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 25
-EXTRAVERSION = .10
+EXTRAVERSION = .11
 NAME = Funky Weasel is Jiggy wit it
 
 # *DOCUMENTATION*
diff --git a/include/asm-x86/desc.h b/include/asm-x86/desc.h
index 5b6a05d..76ea17a 100644
--- a/include/asm-x86/desc.h
+++ b/include/asm-x86/desc.h
@@ -191,8 +191,8 @@ static inline void native_set_ldt(const void *addr, unsigned int entries)
 		unsigned cpu = smp_processor_id();
 		ldt_desc ldt;
 
-		set_tssldt_descriptor(&ldt, (unsigned long)addr,
-				      DESC_LDT, entries * sizeof(ldt) - 1);
+		set_tssldt_descriptor(&ldt, (unsigned long)addr, DESC_LDT,
+				      entries * LDT_ENTRY_SIZE - 1);
 		write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_LDT,
 				&ldt, DESC_LDT);
 		__asm__ __volatile__("lldt %w0"::"q" (GDT_ENTRY_LDT*8));
