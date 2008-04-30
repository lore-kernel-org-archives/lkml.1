Return-Path: <linux-kernel-owner+w=401wt.eu-S1765362AbYD3UvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765362AbYD3UvE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759183AbYD3Uuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:50:54 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44596 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755782AbYD3Uux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:50:53 -0400
Date: Wed, 30 Apr 2008 21:42:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org
Subject: [PATCH 2/2] mm: Fix overcommit overflow
Message-ID: <20080430214239.14452e15@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, one more reason to boot to 2.6.24.5...

This patch needed, too, I guess.

From: Sami Farin <safari-kernel@safari.iki.fi>
Signed-off-by: Sami Farin <safari-kernel@safari.iki.fi>
Signed-off-by: Alan Cox <alan@redhat.com>
Tested-by: Sami Farin <safari-kernel@safari.iki.fi>

diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 3462bfd..a208a7b 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -132,7 +132,7 @@ static int meminfo_read_proc(char *page, char **start, off_t off,
 #define K(x) ((x) << (PAGE_SHIFT - 10))
 	si_meminfo(&i);
 	si_swapinfo(&i);
-	committed = atomic_read(&vm_committed_space);
+	committed = vm_atomic_read(&vm_committed_space);
 	allowed = ((totalram_pages - hugetlb_total_pages())
 		* sysctl_overcommit_ratio / 100) + total_swap_pages;
 


-- 
Do what you love because life is too short for anything else.
