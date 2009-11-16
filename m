Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439AbZKPMUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbZKPMUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbZKPMUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:20:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981AbZKPMTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:19:43 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 35/42] KVM: x86: disable paravirt mmu reporting
Date: Mon, 16 Nov 2009 14:19:36 +0200
Message-Id: <1258373983-8693-36-git-send-email-avi@redhat.com>
In-Reply-To: <1258373983-8693-1-git-send-email-avi@redhat.com>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Disable paravirt MMU capability reporting, so that new (or rebooted)
guests switch to native operation.

Paravirt MMU is a burden to maintain and does not bring significant
advantages compared to shadow anymore.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a06f88e..4693f91 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1238,8 +1238,8 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_NR_MEMSLOTS:
 		r = KVM_MEMORY_SLOTS;
 		break;
-	case KVM_CAP_PV_MMU:
-		r = !tdp_enabled;
+	case KVM_CAP_PV_MMU:	/* obsolete */
+		r = 0;
 		break;
 	case KVM_CAP_IOMMU:
 		r = iommu_found();
-- 
1.6.5.2

