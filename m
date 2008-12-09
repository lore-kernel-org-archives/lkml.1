Return-Path: <linux-kernel-owner+w=401wt.eu-S1756308AbYLIUfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308AbYLIUfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:35:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469AbYLIUYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:24:22 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34881 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754884AbYLIUXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:12 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Glauber Costa <glommer@redhat.com>
Subject: [PATCH 34/44] x86: KVM guest: sign kvmclock as paravirt
Date: Tue,  9 Dec 2008 22:22:49 +0200
Message-Id: <1228854179-23002-35-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <glommer@redhat.com>

Currently, we only set the KVM paravirt signature in case
of CONFIG_KVM_GUEST. However, it is possible to have it turned
off, while CONFIG_KVM_CLOCK is turned on. This is also a paravirt
case, and should be shown accordingly.

Signed-off-by: Glauber Costa <glommer@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kernel/kvmclock.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index e169ae9..b38e801 100644
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
1.6.0.3

