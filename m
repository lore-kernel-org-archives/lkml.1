Return-Path: <linux-kernel-owner+w=401wt.eu-S1752656AbZFYN2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbZFYN2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 09:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbZFYN2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 09:28:14 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:59279 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbZFYN2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 09:28:13 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v5 0/4] irqfd fixes and enhancements
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mst@redhat.com, avi@redhat.com,
       paulmck@linux.vnet.ibm.com, davidel@xmailserver.org,
       rusty@rustcorp.com.au
Date: Thu, 25 Jun 2009 09:28:10 -0400
Message-ID: <20090625132441.26748.641.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Applies to kvm.git/master:4631e094)

The following is the latest attempt to fix the races in irqfd/eventfd, as
well as restore DEASSIGN support.  For more details, please read the patch
headers.

This series has been tested against the kvm-eventfd unit test, and
appears to be functioning properly.  You can download this test here:

ftp://ftp.novell.com/dev/ghaskins/kvm-eventfd.tar.bz2

I've included version 4 of Davide's eventfd patch (ported to kvm.git) so
that its a complete reviewable series.  Note, however, that there may be
later versions of his patch to consider for merging, so we should
coordinate with him.

-Greg

---

Davide Libenzi (1):
      eventfd - revised interface and cleanups (4th rev)

Gregory Haskins (3):
      KVM: add irqfd DEASSIGN feature
      KVM: Fix races in irqfd using new eventfd_kref_get interface
      kvm: prepare irqfd for having interrupts disabled during eventfd->release


 drivers/lguest/lg.h          |    2 
 drivers/lguest/lguest_user.c |    4 -
 fs/aio.c                     |   24 +---
 fs/eventfd.c                 |  126 ++++++++++++++++---
 include/linux/aio.h          |    4 -
 include/linux/eventfd.h      |   35 ++++-
 include/linux/kvm.h          |    2 
 include/linux/kvm_host.h     |    7 +
 virt/kvm/Kconfig             |    1 
 virt/kvm/eventfd.c           |  284 +++++++++++++++++++++++++++++++++---------
 10 files changed, 379 insertions(+), 110 deletions(-)

-- 
Signature
