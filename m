Return-Path: <linux-kernel-owner+w=401wt.eu-S1756385AbZFVQGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385AbZFVQGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbZFVQF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:05:56 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:57991 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbZFVQFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:05:55 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v3 0/3] irqfd/eventfd fixes
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mst@redhat.com, avi@redhat.com,
       paulmck@linux.vnet.ibm.com, davidel@xmailserver.org, mingo@elte.hu,
       rusty@rustcorp.com.au
Date: Mon, 22 Jun 2009 12:05:41 -0400
Message-ID: <20090622155504.22967.50532.stgit@dev.haskins.net>
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

(Note: I believe either the eventfd solution in 2/3, or the patch that
Davide has proposed should work equally well.  Its purely a question of
which direction we want to go in w.r.t. the wakeup registration).

---

Gregory Haskins (3):
      KVM: Fix races in irqfd using new eventfd_kref_get interface
      eventfd: add internal reference counting to fix notifier race conditions
      kvm: prepare irqfd for having interrupts disabled during eventfd->release


 fs/eventfd.c            |   43 ++++++++++--
 include/linux/eventfd.h |    7 ++
 virt/kvm/eventfd.c      |  173 +++++++++++++++++++++++++++++------------------
 3 files changed, 150 insertions(+), 73 deletions(-)

-- 
Signature
