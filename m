Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab0BJRXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:23:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133Ab0BJRXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:11 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/40] KVM: MMU: Report spte not found in rmap before BUG()
Date: Wed, 10 Feb 2010 19:22:32 +0200
Message-Id: <1265822589-11155-4-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the past we've had errors of single-bit in the other two cases; the
printk() may confirm it for the third case (many->many).

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 89a49fb..4f499d7 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -662,6 +662,7 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 			prev_desc = desc;
 			desc = desc->more;
 		}
+		pr_err("rmap_remove: %p %llx many->many\n", spte, *spte);
 		BUG();
 	}
 }
-- 
1.6.5.3

