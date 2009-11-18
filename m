Return-Path: <linux-kernel-owner+w=401wt.eu-S1752415AbZKRFvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbZKRFvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 00:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbZKRFvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 00:51:44 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45915 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbZKRFvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 00:51:44 -0500
Date: Wed, 18 Nov 2009 16:51:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Shreyas Bhatewara <sbhatewara@vmware.com>
Subject: linux-next: net tree build failure
Message-Id: <20091118165145.d0c3114b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Today's linux-next build (powerpc allyesconfig) failed like this:

drivers/net/vmxnet3/vmxnet3_drv.c: In function 'vmxnet3_prepare_tso':
drivers/net/vmxnet3/vmxnet3_drv.c:826: error: implicit declaration of function 'csum_ipv6_magic'

Revealed by commit 115924b6bdc7cc6bf7da5b933b09281e1f4e17a9 ("net:
Getting rid of the x86 dependency to built vmxnet3") which allowed this
driver to be built on PowerPC at all.

I applied this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 18 Nov 2009 16:46:43 +1100
Subject: [PATCH] net: using csum_ipv6_magic requires including net/ip6_checksum.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/vmxnet3/vmxnet3_drv.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 8f24fe5..a4c97e7 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -24,6 +24,8 @@
  *
  */
 
+#include <net/ip6_checksum.h>
+
 #include "vmxnet3_int.h"
 
 char vmxnet3_driver_name[] = "vmxnet3";
-- 
1.6.5.2

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
