Return-Path: <linux-kernel-owner+w=401wt.eu-S932796AbXCBIQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796AbXCBIQd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 03:16:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932859AbXCBIQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 03:16:33 -0500
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:47072 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932796AbXCBIQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 03:16:32 -0500
Subject: [PATCH] hard_smp_processor_id definition for UP systems without
	APIC (i386)
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: vgoyal@in.ibm.com
Cc: Benjamin LaHaise <bcrl@kvack.org>, ebiederm@xmission.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       fastboot@lists.osdl.org, ak@suse.de, akpm@linux-foundation.org,
       judith@linux-foundation.org
In-Reply-To: <1172822794.6025.11.camel@sebastian.intellilink.co.jp>
References: <1172733373.1498.264.camel@sebastian.intellilink.co.jp>
	 <20070301140648.GX26583@kvack.org>  <20070302041455.GA15386@in.ibm.com>
	 <1172822794.6025.11.camel@sebastian.intellilink.co.jp>
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Fri, 02 Mar 2007 17:16:56 +0900
Message-Id: <1172823416.6025.16.camel@sebastian.intellilink.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Provide hard_smp_processor_id definition also for non apic case.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.21-rc2-orig/include/asm-i386/smp.h linux-2.6.21-rc2/include/asm-i386/smp.h
--- linux-2.6.21-rc2-orig/include/asm-i386/smp.h	2007-03-02 16:47:37.000000000 +0900
+++ linux-2.6.21-rc2/include/asm-i386/smp.h	2007-03-02 16:59:42.000000000 +0900
@@ -93,6 +93,7 @@ extern unsigned int num_processors;
 #ifndef __ASSEMBLY__
 
 #ifdef CONFIG_X86_LOCAL_APIC
+
 #ifdef APIC_DEFINITION
 extern int hard_smp_processor_id(void);
 #else
@@ -103,6 +104,13 @@ static inline int hard_smp_processor_id(
 	return GET_APIC_ID(*(unsigned long *)(APIC_BASE+APIC_ID));
 }
 #endif /* APIC_DEFINITION */
+
+#else /* CONFIG_X86_LOCAL_APIC */
+
+#ifndef CONFIG_SMP
+#define hard_smp_processor_id()		0
+#endif
+
 #endif /* CONFIG_X86_LOCAL_APIC */
 
 extern u8 apicid_2_node[];


