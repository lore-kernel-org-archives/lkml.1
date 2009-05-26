Return-Path: <linux-kernel-owner+w=401wt.eu-S1757474AbZEZTPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbZEZTPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 15:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755689AbZEZTPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 15:15:33 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:48239 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbZEZTPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 15:15:32 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v4 0/3] iosignalfd
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, davide@xmailserver.org,
       mtosatti@redhat.com
Date: Tue, 26 May 2009 15:15:23 -0400
Message-ID: <20090526191010.20860.75372.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Applies to kvm.git/master:74dfca0a)

This is v4 of the series.  For more details, please see the header to
patch 3/3.

This series has been tested against the kvm-eventfd unit test, and
appears to be functioning properly.  You can download this test here:

ftp://ftp.novell.com/dev/ghaskins/kvm-eventfd.tar.bz2

This series is ready to be considered for inclusion, pending any further
review comments.

[
   Changelog:

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

Gregory Haskins (3):
      kvm: add iosignalfd support
      kvm: make io_bus interface more robust
      eventfd: export eventfd interfaces for module use


 arch/x86/kvm/i8254.c      |   34 +++++++--
 arch/x86/kvm/i8259.c      |    9 ++-
 arch/x86/kvm/x86.c        |    1 
 fs/eventfd.c              |    3 +
 include/linux/kvm.h       |   15 ++++
 include/linux/kvm_host.h  |   18 ++++-
 virt/kvm/coalesced_mmio.c |    8 ++
 virt/kvm/eventfd.c        |  162 +++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/ioapic.c         |    9 ++-
 virt/kvm/kvm_main.c       |   60 ++++++++++++++---
 10 files changed, 290 insertions(+), 29 deletions(-)

-- 
Signature
