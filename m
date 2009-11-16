Return-Path: <linux-kernel-owner+w=401wt.eu-S1753217AbZKPMT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbZKPMT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbZKPMTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:19:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579AbZKPMTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:19:39 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 04/42] KVM: Don't wrap schedule() with vcpu_put()/vcpu_load()
Date: Mon, 16 Nov 2009 14:19:05 +0200
Message-Id: <1258373983-8693-5-git-send-email-avi@redhat.com>
In-Reply-To: <1258373983-8693-1-git-send-email-avi@redhat.com>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preemption notifiers will do that for us automatically.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/kvm_main.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7495ce3..22b520b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1689,9 +1689,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 		if (signal_pending(current))
 			break;
 
-		vcpu_put(vcpu);
 		schedule();
-		vcpu_load(vcpu);
 	}
 
 	finish_wait(&vcpu->wq, &wait);
-- 
1.6.5.2

