Return-Path: <linux-kernel-owner+w=401wt.eu-S1758851AbYJLNkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851AbYJLNkS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 09:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbYJLNkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 09:40:04 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56644 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbYJLNkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 09:40:03 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [mmotm 10 Oct][PATCH 1/2] fix build error of git-tip
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>
Message-Id: <20081012223808.1817.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Sun, 12 Oct 2008 22:39:58 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Patch name: git-tip-fix.patch
Patch against: mmotm 10 Oct
Applied after: git-tip.patch

-----------
git-tip can't build on ia64 because __acpi_unmap_table() function tyep is wrong.
Then it cause following build error.


  CC      arch/ia64/kernel/acpi.o
arch/ia64/kernel/acpi.c:180: error: conflicting types for '__acpi_unmap_table'
include/linux/acpi.h:82: error: previous declaration of '__acpi_unmap_table' was here
make[1]: *** [arch/ia64/kernel/acpi.o] Error 1
make: *** [arch/ia64/kernel] Error 2


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>

---
 arch/ia64/kernel/acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/arch/ia64/kernel/acpi.c
===================================================================
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -176,7 +176,7 @@ char *__init __acpi_map_table(unsigned l
 	return __va(phys_addr);
 }
 
-char *__init __acpi_unmap_table(unsigned long virt_addr, unsigned long size)
+void __init __acpi_unmap_table(char *virt_addr, unsigned long size)
 {
 }
 


