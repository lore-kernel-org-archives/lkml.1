Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305Ab0CAOfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 09:35:08 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:20311 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab0CAOfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 09:35:00 -0500
X-SpamScore: -3
X-BigFish: VPS-3(zz4015Lzz1202hzzz32i2a8h87h6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYLXTX-01-AW9-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/7 v3] Rework of msrpm optimization and additional fixes for nested svm
Date: Mon, 1 Mar 2010 15:34:33 +0100
Message-ID: <1267454080-2513-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
X-OriginalArrivalTime: 01 Mar 2010 14:34:46.0075 (UTC) FILETIME=[56F0B8B0:01CAB94C]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is the third round of the msrpm merge optimization patches for
nested svm.  The change to the previous post it the introduction of an
direc_access_msrs list which contains all msrs that a guest might
directly access. This list is used to initialize the msrpm bitmaps and
the msrpm_offset table used for merging two tables. This optimization
more than doubles the performance of kernel compiles in the nested guest
using nested-shadow paging.
The other random fixes in this set were not changed to the last version
of this set. Patch 1/7 is new because it was forgotten in the last post.

Thanks,

	Joerg

Diffstat:

 arch/x86/kvm/svm.c |  259 +++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 195 insertions(+), 64 deletions(-)

Shortlog:

Joerg Roedel (7):
      KVM: SVM: Return correct values in nested_svm_exit_handled_msr
      KVM: SVM: Move msrpm offset calculation to seperate function
      KVM: SVM: Introduce direct access msr list
      KVM: SVM: Optimize nested svm msrpm merging
      KVM: SVM: Use svm_msrpm_offset in nested_svm_exit_handled_msr
      KVM; SVM: Add correct handling of nested iopm
      KVM: SVM: Ignore lower 12 bit of nested msrpm_pa



