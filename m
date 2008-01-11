Return-Path: <linux-kernel-owner+w=401wt.eu-S1762368AbYAKTDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762368AbYAKTDN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 14:03:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761639AbYAKTC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 14:02:58 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:51166 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761580AbYAKTC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 14:02:57 -0500
Date: Fri, 11 Jan 2008 20:02:47 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] CRIS v10: kernel/time.c needs to include linux/vmstat.h to compile.
Message-ID: <20080111190247.GG27482@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CRIS v10: kernel/time.c needs to include linux/vmstat.h to compile.

This fixes compile error when nr_free_pages() from linux/swap.h
expands to global_page_state(NR_FREE_PAGES), but linux/vmstat.h isn't
included to declare global_page_state().

---

It seems that most often vmstat.h is not included directly.
Should it perhaps be mm.h that is included instead?


 arch/cris/arch-v10/kernel/time.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/time.c b/arch/cris/arch-v10/kernel/time.c
index 5976f61..525483f 100644
--- a/arch/cris/arch-v10/kernel/time.c
+++ b/arch/cris/arch-v10/kernel/time.c
@@ -13,6 +13,7 @@
 #include <linux/swap.h>
 #include <linux/sched.h>
 #include <linux/init.h>
+#include <linux/vmstat.h>
 #include <asm/arch/svinto.h>
 #include <asm/types.h>
 #include <asm/signal.h>
-- 
1.5.3.6.970.gd25430


/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
