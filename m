Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbZHGJuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbZHGJuF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 05:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbZHGJuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 05:50:04 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:18362 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbZHGJuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 05:50:02 -0400
X-SpamScore: -1
X-BigFish: VPS-1(zz4015Lzz1202hzzz32i203h43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KO03B4-04-L86-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/21] Nested SVM cleanups v2
Date: Fri, 7 Aug 2009 11:49:27 +0200
Message-ID: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 07 Aug 2009 09:49:50.0624 (UTC) FILETIME=[68296A00:01CA1744]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is the second and extended version of my patchset to clean up the code for
SVM virtualization in KVM. The patchset was tested with KVM on KVM and showed
no regressions. It was tested with Nested Paging and with Shadow Paging on the
first-level guest. 
As a major change this patchset enables the nested SVM code by
default. It is still required to start qemu with -enable-nesting,
though.

Changes to the previous version:

	* added Acked-by tags
	* added missing patch descriptions
	* addressed review comments
	* dropped dynamic debugging patch (will be replaced by change
	  to tracing infrastructure)
	* dropped patch moving nested #pf handling because it broke
	  nested SVM with shadow paging
	* added more cleanups (e.g. removed nested_svm_do and
	  function pointer code flow)
	* fixed 2 minor issues
	* enabled nested svm by default

Thanks,

	Joerg

Diffstat:

 arch/x86/kvm/svm.c |  637 +++++++++++++++++++++++++++++-----------------------
 1 files changed, 358 insertions(+), 279 deletions(-)

Shortlog:

Joerg Roedel (21):
      kvm/svm: add helper functions for global interrupt flag
      kvm/svm: optimize nested #vmexit
      kvm/svm: optimize nested vmrun
      kvm/svm: copy only necessary parts of the control area on vmrun/vmexit
      kvm/svm: complete interrupts after handling nested exits
      kvm/svm: move nested svm state into seperate struct
      kvm/svm: cache nested intercepts
      kvm/svm: consolidate nested_svm_exit_handled
      kvm/svm: do nested vmexit in nested_svm_exit_handled
      kvm/svm: simplify nested_svm_check_exception
      kvm/svm: get rid of nested_svm_vmexit_real
      kvm/svm: clean up nested_svm_exit_handled_msr
      kvm/svm: clean up nestec vmload/vmsave paths
      kvm/svm: clean up nested vmrun path
      kvm/svm: remove nested_svm_do and helper functions
      kvm/svm: handle errors in vmrun emulation path appropriatly
      kvm/svm: move special nested exit handling to separate function
      kvm/svm: remove unnecessary is_nested check from svm_cpu_run
      kvm/svm: move nested_svm_intr main logic out of if-clause
      kvm/svm: check for nested VINTR flag in svm_interrupt_allowed
      kvm/svm: enable nested svm by default



