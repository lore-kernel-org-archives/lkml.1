Return-Path: <linux-kernel-owner+w=401wt.eu-S1765751AbZD3Rc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765751AbZD3Rc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763062AbZD3RIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:08:17 -0400
Received: from kroah.org ([198.145.64.141]:56703 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764495AbZD3RID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:08:03 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:46 2009
Message-Id: <20090430165746.681003104@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, mtosatti@redhat.com, avi@redhat.com,
       Gleb Natapov <gleb@redhat.com>
Subject: [patch 56/88] KVM: call kvm_arch_vcpu_reset() instead of the kvm_x86_ops callback
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=kvm-call-kvm_arch_vcpu_reset-instead-of-the-kvm_x86_ops-callback.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Gleb Natapov <gleb@redhat.com>

(cherry picked from 5f179287fa02723215eecf681d812b303c243973)

Call kvm_arch_vcpu_reset() instead of directly using arch callback.
The function does additional things.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/x86.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2973,7 +2973,7 @@ static int __vcpu_run(struct kvm_vcpu *v
 		pr_debug("vcpu %d received sipi with vector # %x\n",
 			 vcpu->vcpu_id, vcpu->arch.sipi_vector);
 		kvm_lapic_reset(vcpu);
-		r = kvm_x86_ops->vcpu_reset(vcpu);
+		r = kvm_arch_vcpu_reset(vcpu);
 		if (r)
 			return r;
 		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;


