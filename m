Return-Path: <linux-kernel-owner+w=401wt.eu-S1756188AbZFBPPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbZFBPPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 11:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754908AbZFBPPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 11:15:39 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:54819 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977AbZFBPPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 11:15:39 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM-RFC PATCH 0/2] irqfd: use POLLHUP notification for close()
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, davidel@xmailserver.org,
       mst@redhat.com, paulmck@linux.vnet.ibm.com
Date: Tue, 02 Jun 2009 11:15:28 -0400
Message-ID: <20090602151135.29746.91320.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Applies to kvm.git/master:25deed73)

Please see the header for 2/2 for a description.  This patch series has
been fully tested and appears to be working correctly.  I have it as an RFC
for now because it needs Davide's official submission/SOB for patch 1/2, and
it should get some eyeballs/acks on my SRCU usage before going in.

I will submit the updated irqfd userspace which eschews the deassign() verb
since we can now just use the close(fd) method alone.  I will also address
the userspace review comments from Avi.

---

Davide Libenzi (1):
      eventfd: send POLLHUP on f_ops->release

Gregory Haskins (1):
      kvm: use POLLHUP to close an irqfd instead of an explicit ioctl


 fs/eventfd.c        |   10 +++
 include/linux/kvm.h |    2 -
 virt/kvm/eventfd.c  |  177 +++++++++++++++++++++++----------------------------
 virt/kvm/kvm_main.c |    3 +
 4 files changed, 90 insertions(+), 102 deletions(-)

-- 
Signature
