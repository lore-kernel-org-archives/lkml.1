Return-Path: <linux-kernel-owner+w=401wt.eu-S1751450AbZJWCi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450AbZJWCi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 22:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbZJWCi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 22:38:56 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:36428 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbZJWCiz (ORCPT
	<rfc822;groupwise-GHaskins@novell.com;0:0>);
	Thu, 22 Oct 2009 22:38:55 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v2 0/2] irqfd enhancements
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net
Date: Thu, 22 Oct 2009 22:38:39 -0400
Message-ID: <20091023023512.3891.65889.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Applies to kvm.git/master:11b06403)

The following patches are cleanups/enhancements for IRQFD now that
we have lockless interrupt injection.  For more details, please see
the patch headers.

These patches pass checkpatch, and are fully tested.  Please consider
for merging.  They are an enhancement only, so there is no urgency
to push to mainline until a suitable merge window presents itself.

Kind Regards,
-Greg

[ Change log:

  v2:
     *) dropped original cleanup which relied on the user registering
        MSI based GSIs or we may crash at runtime.  Instead, we now
	check at registration whether the GSI supports lockless
	operation and dynamically adapt to either the original
	deferred path for lock-based injections, or direct for lockless.

  v1:
     *) original release
]

---

Gregory Haskins (2):
      KVM: Directly inject interrupts if they support lockless operation
      KVM: export lockless GSI attribute


 include/linux/kvm_host.h |    2 ++
 virt/kvm/eventfd.c       |   31 +++++++++++++++++++++++++++----
 virt/kvm/irq_comm.c      |   19 +++++++++++++++++++
 3 files changed, 48 insertions(+), 4 deletions(-)

-- 
Signature
