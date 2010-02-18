Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742Ab0BRLit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 06:38:49 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:11974 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab0BRLir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 06:38:47 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i6bh87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KY1CCC-02-FSP-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/10] Nested SVM fixes (and Win7-64bit bringup)
Date: Thu, 18 Feb 2010 12:38:25 +0100
Message-ID: <1266493115-28386-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
X-OriginalArrivalTime: 18 Feb 2010 11:38:37.0358 (UTC) FILETIME=[E8F33CE0:01CAB08E]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is a couple of fixes for the nested SVM implementation. I collected these
fixes mostly when trying to get Windows 7 64bit running as an L2 guest. Most
important fixes in this set make lazy fpu switching working with nested SVM and
the nested tpr handling fixes. Without the later fix the l1 guest freezes when
trying to run win7 as l2 guest. Please review and comment on these patches :-)

	Joerg

Diffstat:

 arch/x86/kvm/svm.c   |  187 ++++++++++++++++++++++++++++++++++----------------
 arch/x86/kvm/trace.h |   12 ++--
 2 files changed, 133 insertions(+), 66 deletions(-)

Shortlog:

Joerg Roedel (10):
      KVM: SVM: Don't use kmap_atomic in nested_svm_map
      KVM: SVM: Fix wrong interrupt injection in enable_irq_windows
      KVM: SVM: Fix schedule-while-atomic on nested exception handling
      KVM: SVM: Sync all control registers on nested vmexit
      KVM: SVM: Annotate nested_svm_map with might_sleep()
      KVM: SVM: Fix nested msr intercept handling
      KVM: SVM: Don't sync nested cr8 to lapic and back
      KVM: SVM: Activate nested state only when guest state is complete
      KVM: SVM: Make lazy FPU switching work with nested svm
      KVM: SVM: Remove newlines from nested trace points


