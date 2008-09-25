Return-Path: <linux-kernel-owner+w=401wt.eu-S1757573AbYIYMIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573AbYIYMIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755365AbYIYL5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:57:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48644 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755356AbYIYL5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:57:45 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 38/39] KVM: s390: Make facility bits future-proof
Date: Thu, 25 Sep 2008 14:55:10 +0300
Message-Id: <1222343711-12508-39-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

Heiko Carstens pointed out, that its safer to activate working facilities
instead of disabling problematic facilities. The new code uses the host
facility bits and masks it with known good ones.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/s390/kvm/priv.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index d1faf5c..cce40ff 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -157,8 +157,8 @@ static int handle_stfl(struct kvm_vcpu *vcpu)
 	int rc;
 
 	vcpu->stat.instruction_stfl++;
-	facility_list &= ~(1UL<<24); /* no stfle */
-	facility_list &= ~(1UL<<23); /* no large pages */
+	/* only pass the facility bits, which we can handle */
+	facility_list &= 0xfe00fff3;
 
 	rc = copy_to_guest(vcpu, offsetof(struct _lowcore, stfl_fac_list),
 			   &facility_list, sizeof(facility_list));
-- 
1.6.0.1

