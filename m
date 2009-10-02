Return-Path: <linux-kernel-owner+w=401wt.eu-S1757092AbZJBBsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092AbZJBBsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757040AbZJBBsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:48:30 -0400
Received: from kroah.org ([198.145.64.141]:33276 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756567AbZJBBde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:34 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:18 2009
Message-Id: <20091002012418.615583175@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [077/136] KVM: Protect update_cr8_intercept() when running without an apic
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=kvm-protect-update_cr8_intercept-when-running-without-an-apic.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Avi Kivity <avi@redhat.com>

(cherry picked from commit 88c808fd42b53a7e01a2ac3253ef31fef74cb5af)

update_cr8_intercept() can be triggered from userspace while there
is no apic present.

Signed-off-by: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/x86.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3202,6 +3202,9 @@ static void update_cr8_intercept(struct 
 	if (!kvm_x86_ops->update_cr8_intercept)
 		return;
 
+	if (!vcpu->arch.apic)
+		return;
+
 	if (!vcpu->arch.apic->vapic_addr)
 		max_irr = kvm_lapic_find_highest_irr(vcpu);
 	else


