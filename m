Return-Path: <linux-kernel-owner+w=401wt.eu-S1752920Ab0ATPUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab0ATPUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 10:20:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413Ab0ATPUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 10:20:24 -0500
Received: from smtp.nokia.com ([192.100.105.134]:45514 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab0ATPUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 10:20:23 -0500
Date: Wed, 20 Jan 2010 17:19:12 +0200
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mm: Fix nr_good_pages calculation
Message-ID: <20100120151912.GA27747@angel.research.nokia.com>
Reply-To: Jarkko Lavinen <jarkko.lavinen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: GNU/Linux angel.research.nokia.com
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 20 Jan 2010 15:19:14.0637 (UTC) FILETIME=[ED00F7D0:01CA99E3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Swapon wastes one page of swap space to no effect.

Mkswap stores the value 'pages - 1' into last_page field, where pages is the
partition size in pages.  When nr_good_pages is calculated, last_page + 1
should be used for the number of all the pages header included.

Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
---
 mm/swapfile.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 6c0585b..50d90ca 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1961,7 +1961,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (error)
 		goto bad_swap;
 
-	nr_good_pages = swap_header->info.last_page -
+	nr_good_pages = swap_header->info.last_page + 1 -
 			swap_header->info.nr_badpages -
 			1 /* header page */;
 
-- 
1.6.5

