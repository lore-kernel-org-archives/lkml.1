Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbZDXEZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbZDXEZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 00:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbZDXEZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 00:25:14 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:35845 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbZDXEZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 00:25:13 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v2 0/2] irqfd
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, davidel@xmailserver.org
Date: Fri, 24 Apr 2009 00:25:08 -0400
Message-ID: <20090424042142.1796.60756.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Applies to kvm.git b59cd3560111)

This series implements a mechanism called "irqfd".  It lets you create
an eventfd based file-desriptor to inject interrupts to the guest.  We
associate one gsi per fd for proper routing granularity.

This is v2.  Changes since v1

*) Dropped notifier_chain based callbacks in favor of wait_queue_t::func
   and file::poll based callbacks (Thanks to Davide for the suggestion)

--------

We do not have a user of this interface in this series, though note
future version of virtual-bus (v4 and above) will be based on this.

The first patch will require mainline buy-in, particularly from Davide
(cc'd).  The last patch is kvm specific.

kvm-userspace.git patch to follow.

-Greg

---

Gregory Haskins (2):
      kvm: add support for irqfd via eventfd-notification interface
      eventfd: export fget and signal interfaces for module use


 arch/x86/kvm/Makefile    |    2 -
 arch/x86/kvm/x86.c       |    1 
 fs/eventfd.c             |    3 +
 include/linux/kvm.h      |    7 ++
 include/linux/kvm_host.h |    7 ++
 virt/kvm/irqfd.c         |  146 ++++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c      |   12 ++++
 7 files changed, 177 insertions(+), 1 deletions(-)
 create mode 100644 virt/kvm/irqfd.c

-- 
Signature
