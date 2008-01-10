Return-Path: <linux-kernel-owner+w=401wt.eu-S1760499AbYAJQll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760499AbYAJQll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 11:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758179AbYAJQlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 11:41:32 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:1313
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757725AbYAJQlb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 11:41:31 -0500
Message-Id: <478658DC.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 10 Jan 2008 16:41:48 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: clean up linker script
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the dead .text.lock. Move _etext and __{start,stop}___ex_table
into their sections.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
---

 arch/x86/kernel/vmlinux_64.lds.S |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- linux-2.6.24-rc7/arch/x86/kernel/vmlinux_64.lds.S	2008-01-10 16:50:25.000000000 +0100
+++ 2.6.24-rc7-x86_64-linker-script/arch/x86/kernel/vmlinux_64.lds.S	2008-01-08 12:35:11.000000000 +0100
@@ -37,16 +37,15 @@ SECTIONS
 	KPROBES_TEXT
 	*(.fixup)
 	*(.gnu.warning)
-	} :text = 0x9090
-  				/* out-of-line lock text */
-  .text.lock : AT(ADDR(.text.lock) - LOAD_OFFSET) { *(.text.lock) }
-
-  _etext = .;			/* End of text section */
+	_etext = .;			/* End of text section */
+  } :text = 0x9090
 
   . = ALIGN(16);		/* Exception table */
-  __start___ex_table = .;
-  __ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) { *(__ex_table) }
-  __stop___ex_table = .;
+  __ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {
+  	__start___ex_table = .;
+	 *(__ex_table)
+  	__stop___ex_table = .;
+  }
 
   NOTES :text :note
 



