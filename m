Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbYKXPt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbYKXPt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 10:49:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbYKXPtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 10:49:18 -0500
Received: from mx2.redhat.com ([66.187.237.31]:54538 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbYKXPtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 10:49:17 -0500
From: Glauber Costa <glommer@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com
Subject: [PATCH] sign kvmclock as paravirt
Date: Mon, 24 Nov 2008 15:45:23 -0200
Message-Id: <1227548723-18117-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we only set the KVM paravirt signature in case
of CONFIG_KVM_GUEST. However, it is possible to have it turned
off, while CONFIG_KVM_CLOCK is turned on. This is also a paravirt
case, and should be shown accordingly.

Signed-off-by: Glauber Costa <glommer@redhat.com>
---
 arch/x86/kernel/kvmclock.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 1c9cc43..4a1ee5a 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -194,5 +194,7 @@ void __init kvmclock_init(void)
 #endif
 		kvm_get_preset_lpj();
 		clocksource_register(&kvm_clock);
+		pv_info.paravirt_enabled = 1;
+		pv_info.name = "KVM";
 	}
 }
-- 
1.5.6.5

