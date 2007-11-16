Return-Path: <linux-kernel-owner+w=401wt.eu-S1763717AbXKPCdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763717AbXKPCdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 21:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933786AbXKPCdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 21:33:12 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:50896 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765479AbXKPCdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 21:33:11 -0500
Message-Id: <473D0176.6090702@mxs.nes.nec.co.jp>
Date: Fri, 16 Nov 2007 11:33:26 +0900
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, kexec-ml <kexec@lists.infradead.org>
Subject: [PATCH 5/5] Add the array length of "free_list" for filtering free
 pages
References: <473CFE14.3010400@mxs.nes.nec.co.jp>
In-Reply-To: <473CFE14.3010400@mxs.nes.nec.co.jp>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds the array length of "free_area.free_list" to the vmcoreinfo
data so that makedumpfile (dump filtering command) can exclude all free pages
in linux-2.6.24.

makedumpfile creates a small dumpfile by excluding unnecessary pages for the
analysis. To distinguish unnecessary pages, makedumpfile gets the vmcoreinfo
data which has the minimum debugging information only for dump filtering.

In 2.6.24-rc1 or later, the free_area.free_list is an array which has one list
for each migrate types instead of a single list. makedumpfile needs the array
length of "free_area.free_list" and the vmcoreinfo data should contain it.


Signed-off-by: Huang Ying <ying.huang@intel.com>
Tested-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
---
diff -rpuN a/kernel/kexec.c b/kernel/kexec.c
--- a/kernel/kexec.c	2007-11-12 11:15:26.000000000 +0900
+++ b/kernel/kexec.c	2007-11-12 11:16:09.000000000 +0900
@@ -1404,6 +1404,7 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_OFFSET(list_head, next);
 	VMCOREINFO_OFFSET(list_head, prev);
 	VMCOREINFO_LENGTH(zone.free_area, MAX_ORDER);
+	VMCOREINFO_LENGTH(free_area.free_list, MIGRATE_TYPES);
 	VMCOREINFO_NUMBER(NR_FREE_PAGES);
 
 	arch_crash_save_vmcoreinfo();
_

