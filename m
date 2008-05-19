Return-Path: <linux-kernel-owner+w=401wt.eu-S1758575AbYESP1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575AbYESP1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbYESP1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:27:11 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:54923 "EHLO WNmonitoring"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752322AbYESP1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:27:10 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: adobriyan@gmail.com, "Dave Young" <hidave.darkstar@gmail.com>,
       linux-kernel@vger.kernel.org, Mingming Cao <cmm@us.ibm.com>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: ext4-mm-delalloc-ext4-lock-reverse-fix
Date: Mon, 19 May 2008 17:24:47 +0200
Message-Id: <1211210687-4212-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <20080519002919.1f8f21f6.akpm@linux-foundation.org>
References: <20080519002919.1f8f21f6.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 19 May 2008 15:15:09 +0800 "Dave Young" <hidave.darkstar@gmail.com> wrote:
> 
> > Hi,
> > 
> > With 2.6.26-rc2-mm1 I need to sync frequently. It's not normal as my
> > understanding.
> > 
> > 1. scp a big file from a lan server. Firstly the speed is about 8M/s,
> > but the speed will slow down to 100K/s at last. After I exec "sync",
> > the speed will restore.
> > 
> > Is this a known issue?
> > 
> 
> Yes, probably related to the "mkfs takes forever" problem.  I haven't
> looked into it yet.  Nor has anyone else afaik.

Absolutely not sure what this breaks in ext4, but fixes the problem for me:
---
 mm/page-writeback.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 040bc7c..789b6ad 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -881,7 +881,7 @@ int write_cache_pages(struct address_space *mapping,
 	pagevec_init(&pvec, 0);
 	if (wbc->range_cyclic) {
 		index = mapping->writeback_index; /* Start from prev offset */
-		end = wbc->range_end >> PAGE_CACHE_SHIFT;
+		end = -1;
 	} else {
 		index = wbc->range_start >> PAGE_CACHE_SHIFT;
 		end = wbc->range_end >> PAGE_CACHE_SHIFT;
-- 
1.5.4.5

