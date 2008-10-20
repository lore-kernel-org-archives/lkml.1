Return-Path: <linux-kernel-owner+w=401wt.eu-S1753121AbYJTMEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbYJTMEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 08:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbYJTMEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 08:04:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40705 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbYJTMEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 08:04:24 -0400
Date: Mon, 20 Oct 2008 23:04:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, Christopher Harrer <charrer@alacritech.com>,
       Michael Miles <mmiles@alacritech.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linus@vger.kernel.org
Subject: linux-next: build failure
Message-Id: <20081020230420.aa85f83b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next build (powerpc allyesconfig) failed like this:

In file included from drivers/staging/sxg/sxg.c:77:
drivers/staging/sxg/sxghif.h:859: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'Compilation'
drivers/staging/sxg/sxg.c: In function 'sxg_transmit_packet':
drivers/staging/sxg/sxg.c:1949: error: 'SXG_SGL_BUF_SIZE' undeclared (first use in this function)
drivers/staging/sxg/sxg.c:1958: error: implicit declaration of function 'SXG_SGL_BUFFER'
drivers/staging/sxg/sxg.c:1958: warning: assignment makes pointer from integer without a cast
drivers/staging/sxg/sxg.c: In function 'sxg_mcast_set_mask':
drivers/staging/sxg/sxg.c:2846: warning: format '%llx' expects type 'long long unsigned int', but argument 5 has type 'u64'

I applied the following patch.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 20 Oct 2008 22:59:18 +1100
Subject: [PATCH] staging: sxg depends on X86

sxghif.h has code that explicitly will not build fo other architecures.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/staging/sxg/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/sxg/Kconfig b/drivers/staging/sxg/Kconfig
index 1ae3508..6e6cf0b 100644
--- a/drivers/staging/sxg/Kconfig
+++ b/drivers/staging/sxg/Kconfig
@@ -1,6 +1,7 @@
 config SXG
 	tristate "Alacritech SLIC Technology Non-Accelerated 10Gbe support"
 	depends on PCI && NETDEV_10000
+	depends on X86
 	default n
 	help
 	  This driver supports the Alacritech SLIC Technology Non-Accelerated
-- 
1.5.6.5

