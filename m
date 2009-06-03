Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbZFCURv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbZFCURv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 16:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbZFCURm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 16:17:42 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:47557 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbZFCURm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 16:17:42 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v5 0/2] iosignalfd
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, davidel@xmailserver.org,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Date: Wed, 03 Jun 2009 16:17:38 -0400
Message-ID: <20090603200835.8206.8039.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Applies to kvm.git/master:25deed73)

This is v5 of the series.  For more details, please see the header to
patch 2/2.

This series has been tested against the kvm-eventfd unit test, and
appears to be functioning properly.  You can download this test here:

ftp://ftp.novell.com/dev/ghaskins/kvm-eventfd.tar.bz2

This series is ready to be considered for inclusion, pending any further
review comments.

[
   Changelog:

      v5:
           *) Removed "cookie" field, which was a misunderstanding on my
              part on what Avi wanted for a data-match feature
	   *) Added a new "trigger" data-match feature which I think is
              much closer to what we need.
	   *) We retain the dev_count field in the io_bus infrastructure
	      and instead back-fill the array on removal.
	   *) Various minor cleanups
	   *) Rebased to kvm.git/master:25deed73

      v4:
           *) Fixed a bug in the original 2/4 where the PIT failure case
              would potentially leave the io_bus components registered.
           *) Condensed the v3 2/4 and 3/4 into one patch (2/2) since
              the patches became interdependent with the fix described above
           *) Rebased to kvm.git/master:74dfca0a

      v3:
           *) fixed patch 2/4 to handle error cases instead of BUG_ON
           *) implemented same HAVE_EVENTFD protection mechanism as
              irqfd to prevent compilation errors on unsupported arches
           *) completed testing
           *) rebased to kvm.git/master:7391a6d5

      v2:
           *) added optional data-matching capability (via cookie field)
           *) changed name from iofd to iosignalfd
           *) added io_bus unregister function
           *) implemented deassign feature

      v1:
           *) original release (integrated into irqfd v7 series as "iofd")
]

---

Gregory Haskins (2):
      kvm: add iosignalfd support
      kvm: make io_bus interface more robust


 arch/x86/kvm/i8254.c      |   22 +++
 arch/x86/kvm/i8259.c      |    9 +
 arch/x86/kvm/x86.c        |    1 
 include/linux/kvm.h       |   15 ++
 include/linux/kvm_host.h  |   16 ++
 virt/kvm/coalesced_mmio.c |    8 +
 virt/kvm/eventfd.c        |  356 +++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/ioapic.c         |    9 +
 virt/kvm/kvm_main.c       |   41 +++++
 9 files changed, 462 insertions(+), 15 deletions(-)

-- 
Signature
