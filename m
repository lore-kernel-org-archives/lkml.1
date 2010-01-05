Return-Path: <linux-kernel-owner+w=401wt.eu-S932092Ab0AEAt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab0AEAt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:49:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649Ab0AEAtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:49:20 -0500
Received: from kroah.org ([198.145.64.141]:34218 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754277Ab0AEAfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:12 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Marcelo Tosatti <mtosatti@redhat.com>,
       Avi Kivity <avi@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 38/97] KVM: LAPIC: make sure IRR bitmap is scanned after vm load
Date: Mon,  4 Jan 2010 16:32:51 -0800
Message-Id: <1262651630-7354-38-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

commit 6e24a6eff4571002cd48b99a2b92dc829ce39cb9 upstream.

The vcpus are initialized with irr_pending set to false, but
loading the LAPIC registers with pending IRR fails to reset
the irr_pending variable.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/lapic.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 23c2176..41659fb 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1156,6 +1156,7 @@ void kvm_apic_post_state_restore(struct kvm_vcpu *vcpu)
 	hrtimer_cancel(&apic->lapic_timer.timer);
 	update_divide_count(apic);
 	start_apic_timer(apic);
+	apic->irr_pending = true;
 }
 
 void __kvm_migrate_apic_timer(struct kvm_vcpu *vcpu)
-- 
1.6.6

