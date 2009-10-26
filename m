Return-Path: <linux-kernel-owner+w=401wt.eu-S1753610AbZJZQU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbZJZQU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 12:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753576AbZJZQU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 12:20:58 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:35180 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561AbZJZQU6 (ORCPT
	<rfc822;groupwise-GHaskins@novell.com;0:0>);
	Mon, 26 Oct 2009 12:20:58 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v3 0/3] irqfd enhancements, and irq_routing fixes
To: "kvm@vger.kernel.org--cc=alacrityvm-devel"@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Date: Mon, 26 Oct 2009 12:20:51 -0400
Message-ID: <20091026161626.23620.37039.stgit@dev.haskins.net>
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
for merging.  Patch 1/3 is a fix for an issue that may exist upstream
and should be considered for a more timely push upstream.  Patches 2/3
- 3/3 are an enhancement only, so there is no urgency to push to
mainline until a suitable merge window presents itself.

Kind Regards,
-Greg

[ Change log:

  v3:
     *) Added patch 1/3 as a fix for a race condition
     *) Minor cleanup to 2/3 to ensure that all shared vectors conform
        to a unified locking model.

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

Gregory Haskins (3):
      KVM: Directly inject interrupts if they support lockless operation
      KVM: export lockless GSI attribute
      KVM: fix race in irq_routing logic


 include/linux/kvm_host.h |    8 ++++
 virt/kvm/eventfd.c       |   31 +++++++++++++++--
 virt/kvm/irq_comm.c      |   85 ++++++++++++++++++++++++++++++++++------------
 virt/kvm/kvm_main.c      |    1 +
 4 files changed, 98 insertions(+), 27 deletions(-)

-- 
Signature
