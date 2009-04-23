Return-Path: <linux-kernel-owner+w=401wt.eu-S1759313AbZDWPOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313AbZDWPOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 11:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbZDWPOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 11:14:35 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:50151 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbZDWPOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 11:14:34 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH 0/3] irqfd
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, davidel@xmailserver.org
Date: Thu, 23 Apr 2009 11:14:26 -0400
Message-ID: <20090423150910.14094.73708.stgit@dev.haskins.net>
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

We do not have a user of this interface in this series, though note
future version of virtual-bus (v4 and above) will be based on this.

The first two patches will require mainline buy-in, particularly from Davide
(cc'd).  The last patch is kvm specific.

kvm-userspace.git patch to follow.

-Greg

---

Gregory Haskins (3):
      kvm: add support for irqfd via eventfd-notification interface
      eventfd: add a notifier mechanism
      eventfd: export fget and signal interfaces for module use


 arch/x86/kvm/Makefile    |    2 -
 arch/x86/kvm/x86.c       |    1 
 fs/eventfd.c             |   54 +++++++++++++++++++
 include/linux/eventfd.h  |    8 +++
 include/linux/kvm.h      |    7 ++
 include/linux/kvm_host.h |    7 ++
 virt/kvm/irqfd.c         |  133 ++++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c      |   12 ++++
 8 files changed, 223 insertions(+), 1 deletions(-)
 create mode 100644 virt/kvm/irqfd.c

-- 
Signature
