Return-Path: <linux-kernel-owner+w=401wt.eu-S932072AbZEDR57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072AbZEDR57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 13:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755388AbZEDR5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 13:57:48 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:34261 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685AbZEDR5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 13:57:47 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v4 0/2] irqfd
To: kvm@vger.kernel.org
Cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org
Date: Mon, 04 May 2009 13:57:40 -0400
Message-ID: <20090504175657.26758.12503.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Applies to kvm.git:7da2e3ba, plus you will also need Davide Libenzi's
eventfd_file_create() patch, which you can find here:

http://www.mail-archive.com/kvm@vger.kernel.org/msg13923.html

You can find my complete tree with kvm.git, Davide's patch, and this series
here:

http://git.kernel.org/?p=linux/kernel/git/ghaskins/vbus/linux-2.6.git;a=shortlog;h=irqfd

----------------------

irqfd, v4

This series implements a mechanism called "irqfd".  It lets you create
an eventfd based file-desriptor to inject interrupts to a kvm guest. For
more details, please see the prologue for patch 2/2.

[ Changelog:

   v4:
        *) Changed allocation model to create the new fd last, after
           we get past the last potential error point by using Davide's
           new eventfd_file_create interface (Al Viro, Davide Libenzi)
	*) We no longer export sys_eventfd2() since it is replaced
           functionally with eventfd_file_create();
        *) Rebased to kvm.git:7da2e3ba

   v3:
        *) The kernel now allocates the eventfd (need to export sys_eventfd2)
        *) Added a flags field for future expansion to kvm_irqfd()
        *) We properly toggle the irq level 1+0.
        *) We re-use the USERSPACE_SRC_ID instead of creating our own
        *) Properly check for failures establishing a poll-table with eventfd
	*) Fixed fd/file leaks on failure
	*) Rebased to lateste kvm.git::41b76d8d04

   v2:
	*) Dropped notifier_chain based callbacks in favor of
	   wait_queue_t::func and file::poll based callbacks (Thanks to
	   Davide for the suggestion)

   v1:
        *) Initial release

--------

We do not have a user of this interface in this series, though note
future version of virtual-bus (v4 and above) will be based on this.

Note that this series requires userspace patches for qemu-kvm.git, v3, which
you can find here: http://patchwork.kernel.org/patch/20213/

-Greg

---

Gregory Haskins (2):
      kvm: add support for irqfd via eventfd-notification interface
      eventfd: export eventfd interfaces for module use


 arch/x86/kvm/Makefile    |    2 -
 arch/x86/kvm/x86.c       |    1 
 fs/eventfd.c             |    4 +
 include/linux/kvm.h      |    7 ++
 include/linux/kvm_host.h |    4 +
 virt/kvm/irqfd.c         |  159 ++++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c      |   11 +++
 7 files changed, 187 insertions(+), 1 deletions(-)
 create mode 100644 virt/kvm/irqfd.c


