Return-Path: <linux-kernel-owner+w=401wt.eu-S1765629AbZD3Rcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765629AbZD3Rcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764671AbZD3RIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:08:16 -0400
Received: from kroah.org ([198.145.64.141]:56697 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764401AbZD3RID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:08:03 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:46 2009
Message-Id: <20090430165746.524583497@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:44 -0700
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
       alan@lxorguk.ukuu.org.uk, Jan Kiszka <jan.kiszka@siemens.com>,
       mtosatti@redhat.com, avi@redhat.com, Gleb Natapov <gleb@redhat.com>
Subject: [patch 55/88] KVM: x86: Reset pending/inject NMI state on CPU reset
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=kvm-x86-reset-pending-inject-nmi-state-on-cpu-reset.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Kiszka <jan.kiszka@siemens.com>

(cherry picked from 448fa4a9c5dbc6941dd19ed09692c588d815bb06)

CPU reset invalidates pending or already injected NMIs, therefore reset
the related state variables.

Based on original patch by Gleb Natapov.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/x86.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3925,6 +3925,9 @@ void kvm_arch_vcpu_destroy(struct kvm_vc
 
 int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu)
 {
+	vcpu->arch.nmi_pending = false;
+	vcpu->arch.nmi_injected = false;
+
 	return kvm_x86_ops->vcpu_reset(vcpu);
 }
 


