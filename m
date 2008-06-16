Return-Path: <linux-kernel-owner+w=401wt.eu-S1758002AbYFPV4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002AbYFPV4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 17:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757790AbYFPVzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 17:55:33 -0400
Received: from gw.goop.org ([64.81.55.164]:38043 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757631AbYFPVzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 17:55:32 -0400
Message-ID: <4856E12B.6040500@goop.org>
Date: Mon, 16 Jun 2008 14:54:51 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: the arch/x86 maintainers <x86@kernel.org>
CC: Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] xen: set max_pfn_mapped
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to set max_pfn_mapped, so do so.  Xen guarantees that at least 512k is
mapped beyond the end of the kernel image, so we can rely on that being present.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/xen/enlighten.c |    1 +
 1 file changed, 1 insertion(+)

===================================================================
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1266,6 +1266,7 @@
 
 	init_pg_tables_start = __pa(pgd);
 	init_pg_tables_end = __pa(pgd) + xen_start_info->nr_pt_frames*PAGE_SIZE;
+	max_pfn_mapped = (init_pg_tables_end + 512*1024) >> PAGE_SHIFT;
 
 	init_mm.pgd = pgd; /* use the Xen pagetables to start */
 


