Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbYIYMDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbYIYMDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbYIYL4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:56:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48601 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754829AbYIYL4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:56:12 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 29/39] KVM: Allocate guest memory as MAP_PRIVATE, not MAP_SHARED
Date: Thu, 25 Sep 2008 14:55:01 +0300
Message-Id: <1222343711-12508-30-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@qumranet.com>

There is no reason to share internal memory slots with fork()ed instances.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bfc7c33..675d010 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4296,7 +4296,7 @@ int kvm_arch_set_memory_region(struct kvm *kvm,
 			userspace_addr = do_mmap(NULL, 0,
 						 npages * PAGE_SIZE,
 						 PROT_READ | PROT_WRITE,
-						 MAP_SHARED | MAP_ANONYMOUS,
+						 MAP_PRIVATE | MAP_ANONYMOUS,
 						 0);
 			up_write(&current->mm->mmap_sem);
 
-- 
1.6.0.1

