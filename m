Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbYKMRtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbYKMRtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 12:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbYKMRpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 12:45:36 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37319 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396AbYKMRpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 12:45:22 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Zachary Amsden <zach@vmware.com>,
       kexec@lists.infradead.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 09/11] x86: asm/virtext.h: create cpu_emergency_svm_disable()
Date: Thu, 13 Nov 2008 15:43:49 -0200
Message-Id: <1226598231-18311-10-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1226598231-18311-1-git-send-email-ehabkost@redhat.com>
References: <1226598231-18311-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function can be used by the reboot or kdump code to forcibly
disable SVM on the CPU.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/include/asm/virtext.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index 7281e10..e4f6bb0 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -142,4 +142,12 @@ static inline void cpu_svm_disable(void)
 	wrmsrl(MSR_EFER, efer & ~MSR_EFER_SVME_MASK);
 }
 
+/** Makes sure SVM is disabled, if it is supported on the CPU
+ */
+static inline void cpu_emergency_svm_disable(void)
+{
+	if (cpu_has_svm(NULL))
+		cpu_svm_disable();
+}
+
 #endif /* _ASM_X86_VIRTEX_H */
-- 
1.5.5.GIT

