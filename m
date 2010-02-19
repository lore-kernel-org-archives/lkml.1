Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab0BSP1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 10:27:35 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:19581
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751864Ab0BSP1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 10:27:32 -0500
X-SpamScore: -3
X-BigFish: VPS-3(zz4015Lzz1202hzzz32i87h6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KY3HEO-01-M8M-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/11] Nested SVM fixes v2
Date: Fri, 19 Feb 2010 16:22:59 +0100
Message-ID: <1266592990-8911-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
X-OriginalArrivalTime: 19 Feb 2010 15:23:12.0652 (UTC) FILETIME=[7343ACC0:01CAB177]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is the second version of the KVM fixes queued up while testing
nested svm with Windows 7 64 bit. Changes to the previous version:

	* Fixed kunmap bug
	* Introduced nested_svm_intercept insteat of
	  nested_svm_exit_handled_atomic()
	* Added missing patch description
	* Added wbinvd/invd skip functions because the instruction
	  emulator fails on these instructions (found during Windows 7
	  XP mode bringup)

Please review and comment (or apply ;-) these patches.

Thanks,

	Joerg

Shortlog:

Joerg Roedel (11):
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
      KVM: SVM: Don't call instruction emulator for invd and wbinvd

Diffstat:

 arch/x86/kvm/emulate.c |    4 +
 arch/x86/kvm/svm.c     |  218 ++++++++++++++++++++++++++++++++---------------
 arch/x86/kvm/trace.h   |   12 ++--
 3 files changed, 158 insertions(+), 76 deletions(-)


