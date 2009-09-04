Return-Path: <linux-kernel-owner+w=401wt.eu-S1756711AbZIDISK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbZIDISK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 04:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756671AbZIDISG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 04:18:06 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:33253 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbZIDISF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 04:18:05 -0400
Message-Id: <4AA0E95F0200007800013707@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 04 Sep 2009 09:18:07 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: correct segment permission flags in linker
	 script
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While these don't get actively used (afaict), it still doesn't hurt for
them to properly reflect what how respective segments will get mapped/
accessed.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/vmlinux.lds.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.31-rc8/arch/x86/kernel/vmlinux.lds.S	2009-08-28 14:57:38.000000000 +0200
+++ 2.6.31-rc8-x86_64-segment-flags/arch/x86/kernel/vmlinux.lds.S	2009-09-03 11:39:08.000000000 +0200
@@ -45,9 +45,9 @@ PHDRS {
 	text PT_LOAD FLAGS(5);          /* R_E */
 	data PT_LOAD FLAGS(7);          /* RWE */
 #ifdef CONFIG_X86_64
-	user PT_LOAD FLAGS(7);          /* RWE */
+	user PT_LOAD FLAGS(5);          /* R_E */
 #ifdef CONFIG_SMP
-	percpu PT_LOAD FLAGS(7);        /* RWE */
+	percpu PT_LOAD FLAGS(6);        /* RW_ */
 #endif
 	init PT_LOAD FLAGS(7);          /* RWE */
 #endif



