Return-Path: <linux-kernel-owner+w=401wt.eu-S1757590AbYLNIRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590AbYLNIRj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:17:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbYLNIII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:08:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59942 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754133AbYLNIHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:18 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 20/36] powerpc/44x: declare tlb_44x_index for use in C code
Date: Sun, 14 Dec 2008 10:06:53 +0200
Message-Id: <1229242029-13410-21-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

KVM currently ignores the host's round robin TLB eviction selection, instead
maintaining its own TLB state and its own round robin index. However, by
participating in the normal 44x TLB selection, we can drop the alternate TLB
processing in KVM. This results in a significant performance improvement,
since that processing currently must be done on *every* guest exit.

Accordingly, KVM needs to be able to access and increment tlb_44x_index.
(KVM on 440 cannot be a module, so there is no need to export this symbol.)

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Acked-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/mmu-44x.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/mmu-44x.h b/arch/powerpc/include/asm/mmu-44x.h
index a825524..dffa71a 100644
--- a/arch/powerpc/include/asm/mmu-44x.h
+++ b/arch/powerpc/include/asm/mmu-44x.h
@@ -54,6 +54,7 @@
 #ifndef __ASSEMBLY__
 
 extern unsigned int tlb_44x_hwater;
+extern unsigned int tlb_44x_index;
 
 typedef struct {
 	unsigned long id;
-- 
1.6.0.3

