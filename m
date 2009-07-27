Return-Path: <linux-kernel-owner+w=401wt.eu-S1754300AbZG0Hh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbZG0Hh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 03:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754136AbZG0Hh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 03:37:57 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51556 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035AbZG0Hh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 03:37:57 -0400
Date: Mon, 27 Jul 2009 17:37:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: drbd tree build failure
Message-Id: <20090727173754.6a04e781.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

Today's linux-next build (powerpc allyesconfig) failed like this:

drivers/block/drbd/drbd_trace.o: In function `.roles_to_name':
(.text+0x64): multiple definition of `.roles_to_name'
drivers/block/drbd/drbd.o:(.text+0x28eb8): first defined here
drivers/block/drbd/drbd_trace.o: In function `disks_to_name':
(.opd+0x30): multiple definition of `disks_to_name'
drivers/block/drbd/drbd.o:(.opd+0x1b78): first defined here
drivers/block/drbd/drbd_trace.o: In function `roles_to_name':
(.opd+0x18): multiple definition of `roles_to_name'
drivers/block/drbd/drbd.o:(.opd+0x1b60): first defined here
drivers/block/drbd/drbd_trace.o: In function `.conns_to_name':
(.text+0x0): multiple definition of `.conns_to_name'
drivers/block/drbd/drbd.o:(.text+0x28e54): first defined here
drivers/block/drbd/drbd_trace.o: In function `set_st_err_name':
(.opd+0x48): multiple definition of `set_st_err_name'
drivers/block/drbd/drbd.o:(.opd+0x1b90): first defined here
drivers/block/drbd/drbd_trace.o: In function `.disks_to_name':
(.text+0xcc): multiple definition of `.disks_to_name'
drivers/block/drbd/drbd.o:(.text+0x28f20): first defined here
drivers/block/drbd/drbd_trace.o: In function `conns_to_name':
(.opd+0x0): multiple definition of `conns_to_name'
drivers/block/drbd/drbd.o:(.opd+0x1b48): first defined here
drivers/block/drbd/drbd_trace.o: In function `.set_st_err_name':
(.text+0x134): multiple definition of `.set_st_err_name'
drivers/block/drbd/drbd.o:(.text+0x28f88): first defined here

I applied the following patch to mark DRBD_TRACE broken for now.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 27 Jul 2009 17:27:39 +1000
Subject: [PATCH] drbd: tracing is broken

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/block/drbd/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/block/drbd/Kconfig b/drivers/block/drbd/Kconfig
index 8b14ea2..b047662 100644
--- a/drivers/block/drbd/Kconfig
+++ b/drivers/block/drbd/Kconfig
@@ -41,6 +41,7 @@ config BLK_DEV_DRBD
 config DRBD_TRACE
 	tristate "DRBD tracing"
 	depends on BLK_DEV_DRBD
+	depends on BROKEN
 	select TRACEPOINTS
 	default m
 	help
-- 
1.6.3.3

