Return-Path: <linux-kernel-owner+w=401wt.eu-S1757517AbZFDMsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517AbZFDMsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 08:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754407AbZFDMsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 08:48:12 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:52226 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbZFDMsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 08:48:11 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v2 0/2] irqfd: use POLLHUP notification for close()
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, davdel@xmailserver.org,
       mst@redhat.com, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org
Date: Thu, 04 Jun 2009 08:48:02 -0400
Message-ID: <20090604124047.10544.38861.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Applies to kvm.git/master:25deed73)

Please see the header for 2/2 for a description.  This patch series has been
fully tested and appears to be working correctly.

[Review notes:
      *) Paul has looked at the SRCU design and, to my knowledge, didn't find
         any holes.
      *) Michael, Avi, and myself agree that while the removal of the DEASSIGN
         vector is not desirable, the fix on close() is more important in
         the short-term.  We can always add DEASSIGN support again in the
	 future with a CAP bit.
]

[Changelog:

      v2:
         *) Pulled in Davide's official patch for 1/2 from his submission
            accepted into -mmotm.
         *) Fixed patch 2/2 to use the "key" field as a bitmap in the wakeup
            logic, per Davide's feedback.

      v1:
         *) Initial release
]
  

---

Davide Libenzi (1):
      Allow waiters to be notified about the eventfd file* going away, and give

Gregory Haskins (1):
      kvm: use POLLHUP to close an irqfd instead of an explicit ioctl


 fs/eventfd.c        |   10 +++
 include/linux/kvm.h |    2 -
 virt/kvm/eventfd.c  |  177 +++++++++++++++++++++++----------------------------
 virt/kvm/kvm_main.c |    3 +
 4 files changed, 90 insertions(+), 102 deletions(-)

-- 
Signature
