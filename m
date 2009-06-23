Return-Path: <linux-kernel-owner+w=401wt.eu-S1762194AbZFXUEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762194AbZFXUEG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 16:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761686AbZFXUDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 16:03:13 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:37099 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbZFXUDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 16:03:05 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v4 0/4] irqfd fixes
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mst@redhat.com, avi@redhat.com,
       davidel@xmailserver.org, dhowells@redhat.com
Date: Tue, 23 Jun 2009 18:40:32 -0400
Message-ID: <20090623223717.5254.22497.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Applies to kvm.git/master:4631e094)

The following is the latest attempt to fix the remaining races in
irqfd/eventfd.  For more details, please read the patch headers.

This series has been tested against the kvm-eventfd unit test, and
appears to be functioning properly.  You can download this test here:

ftp://ftp.novell.com/dev/ghaskins/kvm-eventfd.tar.bz2

I've included version 2 of Davide's eventfd patch (ported to kvm.git) so
that its a complete reviewable series.  Note, however, that there may be
later versions of his patch to consider for merging, so we should
coordinate with him.

Note also that I potentially found an issue in slow_work which I
subsequently fixed, so I have cc'd David Howells.  It is needed to close
some of the remaining issues.

-Greg

---

Davide Libenzi (1):
      eventfd - revised interface and cleanups (2nd rev)

Gregory Haskins (3):
      KVM: Fix races in irqfd using new eventfd_kref_get interface
      slow-work: add (module*)work->owner to fix races with module clients
      kvm: prepare irqfd for having interrupts disabled during eventfd->release


 drivers/lguest/lg.h          |    2 
 drivers/lguest/lguest_user.c |    4 -
 fs/aio.c                     |   24 +---
 fs/eventfd.c                 |  119 ++++++++++++++++++---
 include/linux/aio.h          |    4 -
 include/linux/eventfd.h      |   18 +--
 include/linux/kvm_host.h     |    7 +
 include/linux/slow-work.h    |    4 +
 init/Kconfig                 |    1 
 kernel/slow-work.c           |    5 +
 virt/kvm/Kconfig             |    1 
 virt/kvm/eventfd.c           |  234 ++++++++++++++++++++++++++++++++----------
 12 files changed, 312 insertions(+), 111 deletions(-)

-- 
Signature
