Return-Path: <linux-kernel-owner+w=401wt.eu-S1752868AbYGXQAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbYGXQAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 12:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbYGXQAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 12:00:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbYGXQAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 12:00:37 -0400
Subject: Re: [PULL] lguest and virtio patches
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Johannes Weiner <hannes@saeurebad.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Carsten Otte <cotte@de.ibm.com>, lguest <lguest@ozlabs.org>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <200807231727.35138.rusty@rustcorp.com.au>
References: <200807231727.35138.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=utf-8
Date: Thu, 24 Jul 2008 16:58:53 +0100
Message-Id: <1216915133.19183.5.camel@muff>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-23 at 17:27 +1000, Rusty Russell wrote:
> (Note the arch/s390 bit is from virtio console on KVM/s390)
> 
> The following changes since commit 0988c37c248e824953d95a11412696c348dbca91:
>   Linus Torvalds (1):
>         Merge branch 'x86-fixes-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip
> 
> are available in the git repository at:
> 
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master
> 
...
> Rusty Russell (19):
>       virtio: Recycle unused recv buffer pages for large skbs in net driver
>       lguest: set max_pfn_mapped, growl loudly at Yinghai Lu
>       lguest: Guest int3 fix
>       lguest: Debugging patch for lguest network performance
>       lguest: fix verbose printing of device features.
>       lguest: virtio-rng support
>       virtio: clarify that ABI is usable by any implementations
>       virtio: don't always force a notification when ring is full
>       lguest: wrap last_avail accesses.
>       lguest: net block unneeded receive queue update notifications
>       lguest: Tell Guest net not to notify us on every packet xmit
>       lguest: Adaptive timeout
>       virtio: Formally reserve bits 28-31 to be 'transport' features.
>       virtio: Rename set_features to finalize_features
>       virtio: Add transport feature handling stub for virtio_ring.

This last one introduces a compile failure; fixup patch below.

Cheers,
Mark.

Subject: [PATCH] virtio: Fix compile error

Include virtio_config.h to fix:

  drivers/virtio/virtio_ring.c: In function ‘vring_transport_features’:
  drivers/virtio/virtio_ring.c:331: error: ‘VIRTIO_TRANSPORT_F_START’ undeclared (first use in this function)
  drivers/virtio/virtio_ring.c:331: error: (Each undeclared identifier is reported only once
  drivers/virtio/virtio_ring.c:331: error: for each function it appears in.)
  drivers/virtio/virtio_ring.c:331: error: ‘VIRTIO_TRANSPORT_F_END’ undeclared (first use in this function)
  make[1]: *** [drivers/virtio/virtio_ring.o] Error 1
  make: *** [drivers/virtio/] Error 2

The include is added by a later patch in Rusty's queue
which wasn't submitted, hence it only coming to light
now.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/virtio/virtio_ring.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index e2671d5..6eb5303 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -18,6 +18,7 @@
  */
 #include <linux/virtio.h>
 #include <linux/virtio_ring.h>
+#include <linux/virtio_config.h>
 #include <linux/device.h>
 
 #ifdef DEBUG
-- 
1.5.5.1

