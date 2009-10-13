Return-Path: <linux-kernel-owner+w=401wt.eu-S1759964AbZJMOEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759964AbZJMOEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 10:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759091AbZJMOEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 10:04:55 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:28104 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759955AbZJMOEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 10:04:54 -0400
X-Trace: 269918160/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.12.149/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.12.149
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEALQl1EpQKQyV/2dsb2JhbACBUY4nAcgvhC0E
X-IronPort-AV: E=Sophos;i="4.44,551,1249254000"; 
   d="scan'208";a="269918160"
Date: Tue, 13 Oct 2009 15:03:59 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andi Kleen <andi@firstfloor.org>
cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] hwpoison: fix/proc/meminfo alignment
Message-ID: <Pine.LNX.4.64.0910131502150.4698@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given such a long name, the kB count in /proc/meminfo's HardwareCorrupted
line is being shown too far right (it does align with x86_64's VmallocChunk
above, but I hope nobody will ever have that much corrupted!).  Align it.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 fs/proc/meminfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 2.6.32-rc4/fs/proc/meminfo.c	2009-09-28 00:28:37.000000000 +0100
+++ linux/fs/proc/meminfo.c	2009-10-13 14:09:12.000000000 +0100
@@ -99,7 +99,7 @@ static int meminfo_proc_show(struct seq_
 		"VmallocUsed:    %8lu kB\n"
 		"VmallocChunk:   %8lu kB\n"
 #ifdef CONFIG_MEMORY_FAILURE
-		"HardwareCorrupted: %8lu kB\n"
+		"HardwareCorrupted: %5lu kB\n"
 #endif
 		,
 		K(i.totalram),
