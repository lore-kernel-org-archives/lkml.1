Return-Path: <linux-kernel-owner+w=401wt.eu-S1752913AbYGLJWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbYGLJWs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 05:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754062AbYGLJW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 05:22:26 -0400
Received: from gw.goop.org ([64.81.55.164]:40340 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbYGLJWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 05:22:24 -0400
Message-ID: <487877C4.3050303@goop.org>
Date: Sat, 12 Jul 2008 02:22:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 3/3] x86_64: adjust exception frame on paranoid exceptions
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exceptions using paranoidentry need to have their exception frames
adjusted explicitly.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/entry_64.S |    6 ++++++
 1 file changed, 6 insertions(+)

===================================================================
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1189,6 +1189,7 @@ END(device_not_available)
 	/* runs on exception stack */
 KPROBE_ENTRY(debug)
  	INTR_FRAME
+	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	pushq $0
 	CFI_ADJUST_CFA_OFFSET 8		
 	paranoidentry do_debug, DEBUG_STACK
@@ -1198,6 +1199,7 @@ KPROBE_END(debug)
 	/* runs on exception stack */	
 KPROBE_ENTRY(nmi)
 	INTR_FRAME
+	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	pushq $-1
 	CFI_ADJUST_CFA_OFFSET 8
 	paranoidentry do_nmi, 0, 0
@@ -1211,6 +1213,7 @@ KPROBE_END(nmi)
 
 KPROBE_ENTRY(int3)
  	INTR_FRAME
+	PARAVIRT_ADJUST_EXCEPTION_FRAME
  	pushq $0
  	CFI_ADJUST_CFA_OFFSET 8
  	paranoidentry do_int3, DEBUG_STACK
@@ -1237,6 +1240,7 @@ END(coprocessor_segment_overrun)
 	/* runs on exception stack */
 ENTRY(double_fault)
 	XCPT_FRAME
+	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	paranoidentry do_double_fault
 	jmp paranoid_exit1
 	CFI_ENDPROC
@@ -1253,6 +1257,7 @@ END(segment_not_present)
 	/* runs on exception stack */
 ENTRY(stack_segment)
 	XCPT_FRAME
+	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	paranoidentry do_stack_segment
 	jmp paranoid_exit1
 	CFI_ENDPROC
@@ -1278,6 +1283,7 @@ END(spurious_interrupt_bug)
 	/* runs on exception stack */
 ENTRY(machine_check)
 	INTR_FRAME
+	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	pushq $0
 	CFI_ADJUST_CFA_OFFSET 8	
 	paranoidentry do_machine_check


