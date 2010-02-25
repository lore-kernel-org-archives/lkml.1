Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932993Ab0BYRQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 12:16:09 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:52019
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932681Ab0BYRQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 12:16:06 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i87h6bh43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYEQMF-02-N9P-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] Rework of msrpm optimization and additional fixes for nested svm
Date: Thu, 25 Feb 2010 18:15:44 +0100
Message-ID: <1267118149-15737-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
X-OriginalArrivalTime: 25 Feb 2010 17:15:52.0364 (UTC) FILETIME=[2ED85EC0:01CAB63E]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is the updated version of the msrpm merge optimization in the nested vmrun
path. With nested-shadow I see a performance improvement by a factor of two in
an up guest with kernel compile times.
A few other fixes are also included like the iopm check for nested io
intercepts and the masking of lower 12 bits of the msrpm address supplied in
the nested vmcb.
Please review and/or apply these changes.

	Joerg

diffstat:

 arch/x86/kvm/svm.c |  187 +++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 133 insertions(+), 54 deletions(-)

shortlog:

Joerg Roedel (5):
      KVM: SVM: Move msrpm offset calculation to seperate function
      KVM: SVM: Optimize nested svm msrpm merging
      KVM: SVM: Use svm_msrpm_offset in nested_svm_exit_handled_msr
      KVM: SVM: Add correct handling of nested iopm
      KVM: SVM: Ignore lower 12 bit of nested msrpm_pa


