Return-Path: <linux-kernel-owner+w=401wt.eu-S1753227AbZKPM2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbZKPM2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbZKPMT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:19:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946AbZKPMTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:19:42 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 33/42] KVM: remove pre_task_link setting in save_state_to_tss16
Date: Mon, 16 Nov 2009 14:19:34 +0200
Message-Id: <1258373983-8693-34-git-send-email-avi@redhat.com>
In-Reply-To: <1258373983-8693-1-git-send-email-avi@redhat.com>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Juan Quintela <quintela@redhat.com>

Now, also remove pre_task_link setting in save_state_to_tss16.

  commit b237ac37a149e8b56436fabf093532483bff13b0
  Author: Gleb Natapov <gleb@redhat.com>
  Date:   Mon Mar 30 16:03:24 2009 +0300

    KVM: Fix task switch back link handling.

CC: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/x86.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6f75856..5f44d56 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4203,7 +4203,6 @@ static void save_state_to_tss16(struct kvm_vcpu *vcpu,
 	tss->ss = get_segment_selector(vcpu, VCPU_SREG_SS);
 	tss->ds = get_segment_selector(vcpu, VCPU_SREG_DS);
 	tss->ldt = get_segment_selector(vcpu, VCPU_SREG_LDTR);
-	tss->prev_task_link = get_segment_selector(vcpu, VCPU_SREG_TR);
 }
 
 static int load_state_from_tss16(struct kvm_vcpu *vcpu,
-- 
1.6.5.2

