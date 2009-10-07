Return-Path: <linux-kernel-owner+w=401wt.eu-S1759440AbZJGOdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440AbZJGOdG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 10:33:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759314AbZJGOdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 10:33:05 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:14824
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759416AbZJGOdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 10:33:03 -0400
X-SpamScore: -10
X-BigFish: VPS-10(zz15bfO4015Lzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KR5F0L-01-FE0-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/10] KVM: Nested SVM fixes and tracepoint conversion
Date: Wed, 7 Oct 2009 16:31:18 +0200
Message-ID: <1254925888-13743-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.4.3
X-OriginalArrivalTime: 07 Oct 2009 14:31:33.0467 (UTC) FILETIME=[DE3D52B0:01CA475A]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi, Marcelo,

this series of patches contains bugfixes for the Nested SVM code and the
conversion of Nested SVM debugging to tracepoints. The fixes are:

	1) A patch Alex already sent (1/10) but which was not yet
	   applied. It fixes a lost event_inj problem when we emulate
	   a vmrun and a vmexit without entering the guest in
	   the meantime.

	2) The patches 2/10 and 3/10 fixing a schedule() while atomic
	   bug in the Nested SVM code. The KVM interrupt injection code
	   runs with preemtion and interrupts disabled. But the
	   enable_irq_window() function from SVM may emulate a #vmexit.
	   This emulation migth sleep which causes the schedule() while
	   atomic() bug.

These fixes (patches 1 to 3) should also be considered for -stable
backporting.

The patches 3 to 9 convert the old printk based debugging for Nested
SVM to tracepoints. Patch 10 removes the nsvm_printk code. Please review
and/or consider to apply these changes.

Thanks,

	Joerg

diffstat:

 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/svm.c              |   98 +++++++++++++++---------
 arch/x86/kvm/trace.h            |  165 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c              |   23 ++++++
 include/linux/kvm_host.h        |    1 +
 5 files changed, 252 insertions(+), 36 deletions(-)

shortlog:

Alexander Graf (1):
      KVM: SVM: Notify nested hypervisor of lost event injections

Joerg Roedel (9):
      KVM: X86: Add KVM_REQ_VMEXIT to trigger a nested #vmexit
      KVM: SVM: Move nested INTR #vmexit into preemtible code
      KVM: SVM: Add tracepoint for nested vmrun
      KVM: SVM: Add tracepoint for nested #vmexit
      KVM: SVM: Add tracepoint for injected #vmexit
      KVM: SVM: Add tracepoint for #vmexit because intr pending
      KVM: SVM: Add tracepoint for invlpga instruction
      KVM: SVM: Add tracepoint for skinit instruction
      KVM: SVM: Remove nsvm_printk debugging code


