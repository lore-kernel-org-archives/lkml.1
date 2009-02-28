Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbZB1BmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbZB1BmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbZB1Bl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:41:57 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41761 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091AbZB1Bl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:41:56 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/30] KVM: s390: Fix printk on SIGP set arch
Date: Sat, 28 Feb 2009 03:41:23 +0200
Message-Id: <1235785309-12835-5-git-send-email-avi@redhat.com>
In-Reply-To: <1235785309-12835-1-git-send-email-avi@redhat.com>
References: <1235785309-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

KVM on s390 does not support the ESA/390 architecture. We refuse to
change the architecture mode and print a warning. This patch removes
the printk for several reasons:

o A malicious guest can flood host dmesg
o The old message had no newline
o there is no connection between the message and the failing guest

This patch simply removes the printk. We already set the condition
code to 3 - the guest knows that something went wrong.

Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/s390/kvm/sigp.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
index 2a01b9e..f27dbed 100644
--- a/arch/s390/kvm/sigp.c
+++ b/arch/s390/kvm/sigp.c
@@ -153,8 +153,6 @@ static int __sigp_set_arch(struct kvm_vcpu *vcpu, u32 parameter)
 
 	switch (parameter & 0xff) {
 	case 0:
-		printk(KERN_WARNING "kvm: request to switch to ESA/390 mode"
-							" not supported");
 		rc = 3; /* not operational */
 		break;
 	case 1:
-- 
1.6.0.6

