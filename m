Return-Path: <linux-kernel-owner+w=401wt.eu-S1758598AbYKEUDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbYKEUDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 15:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756093AbYKET6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 14:58:33 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41456 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756877AbYKET6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 14:58:16 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 12/15] kvm: svm: no-parameters version of svm_hardware_disable()
Date: Wed,  5 Nov 2008 17:56:55 -0200
Message-Id: <1225915018-6548-13-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1225915018-6548-1-git-send-email-ehabkost@redhat.com>
References: <1225915018-6548-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create __svm_hardware_disable(), a function we can use for
set_virt_disable_func().

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/kvm/svm.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f0ad4d4..3d330a2 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -266,7 +266,7 @@ static int has_svm(void)
 	return 1;
 }
 
-static void svm_hardware_disable(void *garbage)
+static void __svm_hardware_disable(void)
 {
 	uint64_t efer;
 
@@ -275,6 +275,11 @@ static void svm_hardware_disable(void *garbage)
 	wrmsrl(MSR_EFER, efer & ~MSR_EFER_SVME_MASK);
 }
 
+static void svm_hardware_disable(void *garbage)
+{
+	__svm_hardware_disable();
+}
+
 static void svm_hardware_enable(void *garbage)
 {
 
-- 
1.5.5.GIT

