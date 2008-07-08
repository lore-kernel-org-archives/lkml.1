Return-Path: <linux-kernel-owner+w=401wt.eu-S1758318AbYGHXSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318AbYGHXSu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757505AbYGHXOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:14:46 -0400
Received: from gw.goop.org ([64.81.55.164]:51209 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756188AbYGHXOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:42 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 23 of 55] xen64: add asm-offsets
X-Mercurial-Node: 1c01d0b7f04a76638a7cc69b99e5a43714eabd34
Message-Id: <1c01d0b7f04a76638a7c.1215554805@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:45 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Xen vcpu_info offsets to asm-offsets_64.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/asm-offsets_64.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -17,6 +17,8 @@
 #include <asm/thread_info.h>
 #include <asm/ia32.h>
 #include <asm/bootparam.h>
+
+#include <xen/interface/xen.h>
 
 #define __NO_STUBS 1
 #undef __SYSCALL
@@ -134,5 +136,11 @@
 
 	BLANK();
 	DEFINE(PAGE_SIZE_asm, PAGE_SIZE);
+#ifdef CONFIG_XEN
+	BLANK();
+	OFFSET(XEN_vcpu_info_mask, vcpu_info, evtchn_upcall_mask);
+	OFFSET(XEN_vcpu_info_pending, vcpu_info, evtchn_upcall_pending);
+#undef ENTRY
+#endif
 	return 0;
 }


