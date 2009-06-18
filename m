Return-Path: <linux-kernel-owner+w=401wt.eu-S1752553AbZFRRoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbZFRRoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 13:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755287AbZFRRoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 13:44:25 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:34147 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbZFRRoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 13:44:24 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH 0/4] irqfd fixes/enhancements
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, davidel@xmailserver.org, mingo@elte.hu,
       mst@redhat.com, avi@redhat.com, paulmck@linux.vnet.ibm.com,
       rusty@rustcorp.com.au
Date: Thu, 18 Jun 2009 13:44:11 -0400
Message-ID: <20090618173534.24119.95115.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Applies to kvm.git/master:c27b64a0)

The following series represents my queue of fixes for issues in irqfd, 
which include enhancements to eventfd.  This is a respin of the patches
originally proposed yesterday, called "[KVM-RFC PATCH 0/2] eventfd
enhancements for irqfd/iosignalfd", which you can find a link to the thread
here:

http://www.gossamer-threads.com/lists/linux/kernel/1091852

Aside from introducing a few minor fixes (patches 1/4, 2/4), the general
solution for module reference counting has been extracted from the
(controversial) SRCU enhancement.  We can address the SRCU topic at a later
time.  For now, fixing the race condition is a higher priority item IMO.
Hopefully, this more focused series is more palatable for the
reviewers/maintainers involved.

---

Gregory Haskins (4):
      eventfd: add module reference counting support for registered notifiers
      eventfd: add generalized notifier interface
      KVM: fix irqfd error checking
      KVM: update inaccurate irqfd comment


 fs/eventfd.c            |   77 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/eventfd.h |   37 +++++++++++++++++++++
 virt/kvm/eventfd.c      |   82 ++++++++++++++++++-----------------------------
 3 files changed, 146 insertions(+), 50 deletions(-)

-- 

