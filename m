Return-Path: <linux-kernel-owner+w=401wt.eu-S1756986AbYILOmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986AbYILOmr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 10:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbYILOmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 10:42:37 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:23125 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbYILOmg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 10:42:36 -0400
Message-Id: <48CA9C18.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Fri, 12 Sep 2008 15:43:04 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: fix combining of regions in
	 init_memory_mapping()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When nr_range gets decremented, the same slot must be considered for
coalescing with its new successor again.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/mm/init_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.27-rc6/arch/x86/mm/init_64.c	2008-08-29 10:53:00.000000000 +0200
+++ 2.6.27-rc6-x86_64-mr-coalesce/arch/x86/mm/init_64.c	2008-09-12 11:58:45.000000000 +0200
@@ -636,7 +636,7 @@ unsigned long __init_refok init_memory_m
 		old_start = mr[i].start;
 		memmove(&mr[i], &mr[i+1],
 			 (nr_range - 1 - i) * sizeof (struct map_range));
-		mr[i].start = old_start;
+		mr[i--].start = old_start;
 		nr_range--;
 	}
 



