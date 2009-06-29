Return-Path: <linux-kernel-owner+w=401wt.eu-S1759575AbZF2PoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759575AbZF2PoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 11:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755332AbZF2PoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 11:44:07 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:40396 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbZF2PoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 11:44:06 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v6 0/4] irqfd fixes and enhancements
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mst@redhat.com, avi@redhat.com,
       davidel@xmailserver.org
Date: Mon, 29 Jun 2009 11:43:59 -0400
Message-ID: <20090629153627.31959.76947.stgit@dev.haskins.net>
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

You can also find this applied as a git tree:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/ghaskins/linux-2.6-hacks.git kvm/irqfd

For reviewing convenience, here is a link to the entire virt/kvm/eventfd.c
file after the patches are applied:

http://git.kernel.org/?p=linux/kernel/git/ghaskins/linux-2.6-hacks.git;a=blob;f=virt/kvm/eventfd.c;h=409d9e160f1f85618a5e3772937b2721a249399a;hb=85cfd57e33dcaea29971513334ca003764653b21

As always, this series has been tested against the kvm-eventfd unit test, and
appears to be functioning properly. You can download this test here:

ftp://ftp.novell.com/dev/ghaskins/kvm-eventfd.tar.bz2

I've included version 4 of Davide's eventfd patch (ported to kvm.git) so
that its a complete reviewable series.  Note, however, that there may be
later versions of his patch to consider for merging, so we should
coordinate with him.

-Greg


[Changelog:

	v6:
	   *) Removed slow-work in favor of using a dedicated single-thread
              workqueue.
	   *) Condensed cleanup path to always use deferred shutdown
	   *) Saved about 56 lines over v5, with the following diffstat:

 	   include/linux/kvm_host.h |    2 
 	   virt/kvm/eventfd.c       |  248 ++++++++++++++++++-----------------------------
 	   2 files changed, 97 insertions(+), 153 deletions(-)

	v5:
           Untracked..
]

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
 fs/eventfd.c                 |  126 ++++++++++++++++++++---
 include/linux/aio.h          |    4 -
 include/linux/eventfd.h      |   35 +++++-
 include/linux/kvm.h          |    2 
 include/linux/kvm_host.h     |    5 +
 virt/kvm/Kconfig             |    1 
 virt/kvm/eventfd.c           |  229 +++++++++++++++++++++++++++++++-----------
 10 files changed, 321 insertions(+), 111 deletions(-)

-- 
Signature
