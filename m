Return-Path: <linux-kernel-owner+w=401wt.eu-S1755745AbZEUQuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbZEUQuO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 12:50:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754031AbZEUQts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 12:49:48 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:44664 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbZEUQtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 12:49:45 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v3 0/4] iosignalfd
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, --cc=mtosatti@redhat.com
Date: Thu, 21 May 2009 12:49:26 -0400
Message-ID: <20090521164241.14617.92951.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Applies to kvm.git/master:7391a6d5)

This is v3 of the series.  For more details, please see the header to
patch 4/4.

This series has been tested against the kvm-eventfd unit test, and
appears to be functioning properly.  You can download this test here:

ftp://ftp.novell.com/dev/ghaskins/kvm-eventfd.tar.bz2

(Note that the test released with irqfd had a bug in it that prevented
iosignalfd from working properly.  The tarball has been updated with the
fix)

This series is ready to be considered for inclusion, pending any further
review comments.

[
   Changelog:

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

Gregory Haskins (4):
      kvm: add iosignalfd support
      kvm: add io_bus unregister function
      kvm: add return value to kvm_io_bus_register_dev
      eventfd: export eventfd interfaces for module use


 arch/x86/kvm/i8254.c      |   27 +++++--
 arch/x86/kvm/i8259.c      |    9 ++
 arch/x86/kvm/x86.c        |    1 
 fs/eventfd.c              |    3 +
 include/linux/kvm.h       |   15 ++++
 include/linux/kvm_host.h  |   18 ++++-
 virt/kvm/coalesced_mmio.c |    8 ++
 virt/kvm/eventfd.c        |  165 +++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/ioapic.c         |    9 ++
 virt/kvm/kvm_main.c       |   60 ++++++++++++++--
 10 files changed, 286 insertions(+), 29 deletions(-)

-- 
Signature
