Return-Path: <linux-kernel-owner+w=401wt.eu-S1756432AbYGUXuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432AbYGUXuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 19:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469AbYGUXuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 19:50:14 -0400
Received: from gw.goop.org ([64.81.55.164]:33969 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755241AbYGUXuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 19:50:11 -0400
Message-ID: <488520A6.8000303@goop.org>
Date: Mon, 21 Jul 2008 16:49:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mark McLoughlin <markmc@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] xen: don't use sysret for sysexit32
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When implementing sysexit32, don't let Xen use sysret to return to
userspace.  That results in usermode register state being trashed.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/xen-asm_64.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

===================================================================
--- a/arch/x86/xen/xen-asm_64.S
+++ b/arch/x86/xen/xen-asm_64.S
@@ -173,7 +173,7 @@
 	pushq $__USER32_CS
 	pushq %rdx
 
-	pushq $VGCF_in_syscall
+	pushq $0
 1:	jmp hypercall_iret
 ENDPATCH(xen_sysexit)
 RELOC(xen_sysexit, 1b+1)


