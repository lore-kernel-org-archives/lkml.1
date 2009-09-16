Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbZIPNZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbZIPNZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757162AbZIPNZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:25:53 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:20175 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757103AbZIPNZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:25:50 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz4015Lzz1202hzzz32i203h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KQ2FX4-01-3NG-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alexander Graf <agraf@suse.de>
Subject: [PATCH 0/5] Another set of Nested SVM fixes and cleanups
Date: Wed, 16 Sep 2009 15:24:14 +0200
Message-ID: <1253107459-8967-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 16 Sep 2009 13:24:23.0156 (UTC) FILETIME=[014FEB40:01CA36D1]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series of patches contain another set of cleanups and an important fix to
the Nested SVM code. These patches make the TSC handling code for SVM aware of
a nested guest. This fixes the TSC running backwards on guest and nested guest.
The backwards running TSC resulted in stalled guests when kvm-clock was
enabled. Please consider to apply.

Thanks,

	Joerg

Shortlog:

Joerg Roedel (5):
      KVM: SVM: reorganize svm_interrupt_allowed
      KVM: SVM: don't copy exit_int_info on nested vmrun
      KVM: SVM: Fix tsc offset adjustment when running nested
      KVM: SVM: Handle tsc in svm_get_msr/svm_set_msr correctly
      KVM: SVM: Remove remaining occurences of rdtscll


Diffstat:

 arch/x86/kvm/svm.c |   50 ++++++++++++++++++++++++++++++++++----------------
 1 files changed, 34 insertions(+), 16 deletions(-)


