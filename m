Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab0BXR7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 12:59:53 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:10933 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757525Ab0BXR7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 12:59:50 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i6bh87h63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYCXZ5-02-PK2-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 08/11] KVM: x86: Don't set arch.cr0 in kvm_set_cr0
Date: Wed, 24 Feb 2010 18:59:17 +0100
Message-ID: <1267034360-5907-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267034360-5907-1-git-send-email-joerg.roedel@amd.com>
References: <1267034360-5907-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 24 Feb 2010 17:59:23.0683 (UTC) FILETIME=[18E64730:01CAB57B]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vcpu->arch.cr0 variable is already set in the
architecture specific set_cr0 callbacks. There is no need to
set it in the common code.
This allows the architecture code to keep the old arch.cr0
value if it wants. This is required for nested svm to decide
if a selective_cr0 exit needs to be injected.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/x86.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 31d44c1..a81046b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -485,7 +485,6 @@ void kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	}
 
 	kvm_x86_ops->set_cr0(vcpu, cr0);
-	vcpu->arch.cr0 = cr0;
 
 	kvm_mmu_reset_context(vcpu);
 	return;
-- 
1.7.0


