Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935204Ab0CMAZ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:25:56 -0500
Received: from kroah.org ([198.145.64.141]:32885 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935063Ab0CMAVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:21:10 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:15 2010
Message-Id: <20100313001515.372453718@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:13:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [patch 117/123] KVM: x86 emulator: Forbid modifying CS segment register by mov instruction
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Gleb Natapov <gleb@redhat.com>

commit 8b9f44140bc4afd2698413cd9960c3912168ee91 upstream.

Inject #UD if guest attempts to do so. This is in accordance to Intel
SDM.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/emulate.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1987,6 +1987,12 @@ special_insn:
 		int err;
 
 		sel = c->src.val;
+
+		if (c->modrm_reg == VCPU_SREG_CS) {
+			kvm_queue_exception(ctxt->vcpu, UD_VECTOR);
+			goto done;
+		}
+
 		if (c->modrm_reg == VCPU_SREG_SS)
 			toggle_interruptibility(ctxt, X86_SHADOW_INT_MOV_SS);
 


