Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab0BJRZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:25:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755773Ab0BJRXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:15 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 40/40] KVM: PPC: Fix typo in rebolting code
Date: Wed, 10 Feb 2010 19:23:09 +0200
Message-Id: <1265822589-11155-41-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

When we're loading bolted entries into the SLB again, we're checking if an
entry is in use and only slbmte it when it is.

Unfortunately, the check always goes to the skip label of the first entry,
resulting in an endless loop when it actually gets triggered.

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/powerpc/kvm/book3s_64_slb.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_slb.S b/arch/powerpc/kvm/book3s_64_slb.S
index ecd237a..8e44788 100644
--- a/arch/powerpc/kvm/book3s_64_slb.S
+++ b/arch/powerpc/kvm/book3s_64_slb.S
@@ -31,7 +31,7 @@
 #define REBOLT_SLB_ENTRY(num) \
 	ld	r10, SHADOW_SLB_ESID(num)(r11); \
 	cmpdi	r10, 0; \
-	beq	slb_exit_skip_1; \
+	beq	slb_exit_skip_ ## num; \
 	oris	r10, r10, SLB_ESID_V@h; \
 	ld	r9, SHADOW_SLB_VSID(num)(r11); \
 	slbmte	r9, r10; \
-- 
1.6.5.3

