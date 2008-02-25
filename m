Return-Path: <linux-kernel-owner+w=401wt.eu-S1757539AbYBYRnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539AbYBYRnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 12:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbYBYRnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 12:43:42 -0500
Received: from krynn.se.axis.com ([193.13.178.10]:60644 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbYBYRnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 12:43:41 -0500
Date: Mon, 25 Feb 2008 18:43:21 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>
Subject: [PATCH] CRIS v10: Include mm.h instead of vmstat.h in kernel/time.c
Message-ID: <20080225174320.GF24124@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2f569afd9ced9ebec9a6eb3dbf6f83429be0a7b4
(CONFIG_HIGHPTE vs. sub-page page tables) introduced use of
inc_zone_page_state and dec_zone_page_state in include/linux/mm.h.

Those are defined in include/linux/vmstat.h, but after it includes
mm.h, making it impossible to include vmstat.h since inc_zone_page_state
and dec_zone_page_state then would be undefined.

arch/cris/arch-v10/kernel/time.c does just this, which makes the
CRIS v10 build break with the following error:

...
  CC      arch/cris/arch-v10/kernel/time.o
In file included from include/linux/vmstat.h:7,
                 from arch/cris/arch-v10/kernel/time.c:17:
include/linux/mm.h: In function 'pgtable_page_ctor':
include/linux/mm.h:902: error: implicit declaration of function 'inc_zone_page_state'
include/linux/mm.h: In function 'pgtable_page_dtor':
include/linux/mm.h:908: error: implicit declaration of function 'dec_zone_page_state'
make[2]: *** [arch/cris/arch-v10/kernel/time.o] Error 1
make[1]: *** [arch/cris/arch-v10/kernel] Error 2
make: *** [sub-make] Error 2
...

By changing kernel/time.c to include linux/mm.h, the build succeeds.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v10/kernel/time.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/time.c b/arch/cris/arch-v10/kernel/time.c
index 9310a7b..525483f 100644
--- a/arch/cris/arch-v10/kernel/time.c
+++ b/arch/cris/arch-v10/kernel/time.c
@@ -13,7 +13,7 @@
 #include <linux/swap.h>
 #include <linux/sched.h>
 #include <linux/init.h>
-#include <linux/vmstat.h>
+#include <linux/mm.h>
 #include <asm/arch/svinto.h>
 #include <asm/types.h>
 #include <asm/signal.h>
-- 
1.5.4.2.133.g3d51e


/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
