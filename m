Return-Path: <linux-kernel-owner+w=401wt.eu-S1756190AbZERJ3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbZERJ3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755668AbZERJX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:23:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38403 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbZERJXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:09 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 14/43] KVM: PIT: remove unused scheduled variable
Date: Mon, 18 May 2009 12:22:36 +0300
Message-Id: <1242638585-18470-15-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Unused.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/i8254.c |    1 -
 arch/x86/kvm/i8254.h |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index c13bb92..3eddae6 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -208,7 +208,6 @@ static int __pit_timer_fn(struct kvm_kpit_state *ps)
 		wake_up_interruptible(&vcpu0->wq);
 
 	hrtimer_add_expires_ns(&pt->timer, pt->period);
-	pt->scheduled = hrtimer_get_expires_ns(&pt->timer);
 	if (pt->period)
 		ps->channels[0].count_load_time = ktime_get();
 
diff --git a/arch/x86/kvm/i8254.h b/arch/x86/kvm/i8254.h
index 6acbe4b..521accf 100644
--- a/arch/x86/kvm/i8254.h
+++ b/arch/x86/kvm/i8254.h
@@ -7,7 +7,6 @@ struct kvm_kpit_timer {
 	struct hrtimer timer;
 	int irq;
 	s64 period; /* unit: ns */
-	s64 scheduled;
 	atomic_t pending;
 	bool reinject;
 };
-- 
1.6.0.6

