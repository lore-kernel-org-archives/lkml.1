Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbXLJQiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbXLJQiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 11:38:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829AbXLJQh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 11:37:57 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:27367
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752589AbXLJQh4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 11:37:56 -0500
Message-Id: <475D79A4.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 10 Dec 2007 16:38:44 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@redhat.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: fix a few paravirt-related modpost warnings
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 arch/x86/kernel/head_32.S |    2 +-
 arch/x86/xen/setup.c      |    2 +-
 arch/x86/xen/xen-head.S   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.24-rc4/arch/x86/kernel/head_32.S	2007-12-07 09:00:59.000000000 +0100
+++ 2.6.24-rc4-i386-lguest-warning/arch/x86/kernel/head_32.S	2007-12-05 18:30:33.000000000 +0100
@@ -151,7 +151,7 @@ WEAK(xen_entry)
 	/* Unknown implementation; there's really
 	   nothing we can do at this point. */
 	ud2a
-.data
+.section .init.data, "aw"
 subarch_entries:
 	.long default_entry		/* normal x86/PC */
 	.long lguest_entry		/* lguest hypervisor */
--- linux-2.6.24-rc4/arch/x86/xen/setup.c	2007-12-07 09:01:00.000000000 +0100
+++ 2.6.24-rc4-i386-lguest-warning/arch/x86/xen/setup.c	2007-12-10 17:31:06.000000000 +0100
@@ -59,7 +59,7 @@ static void xen_idle(void)
 /*
  * Set the bit indicating "nosegneg" library variants should be used.
  */
-static void fiddle_vdso(void)
+static __init void fiddle_vdso(void)
 {
 	extern u32 VDSO_NOTE_MASK; /* See ../kernel/vsyscall-note.S.  */
 	extern char vsyscall_int80_start;
--- linux-2.6.24-rc4/arch/x86/xen/xen-head.S	2007-12-07 09:01:00.000000000 +0100
+++ 2.6.24-rc4-i386-lguest-warning/arch/x86/xen/xen-head.S	2007-12-10 17:25:46.000000000 +0100
@@ -7,7 +7,7 @@
 #include <asm/boot.h>
 #include <xen/interface/elfnote.h>
 
-.pushsection .init.text
+.pushsection .init.text, "ax"
 ENTRY(startup_xen)
 	movl %esi,xen_start_info
 	cld



