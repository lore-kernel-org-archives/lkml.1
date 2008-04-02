Return-Path: <linux-kernel-owner+w=401wt.eu-S1758116AbYDBSgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116AbYDBSgF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbYDBSfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:35:33 -0400
Received: from 21.sub-75-208-3.myvzw.com ([75.208.3.21]:38398 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755032AbYDBSfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:35:32 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 19 of 24] x86: fix build problem in pud_populate without
	CONFIG_PARAVIRT
X-Mercurial-Node: 6490118c8c89b9cbd410bc35bdc92e87477f8ada
Message-Id: <6490118c8c89b9cbd410.1207158848@localhost>
In-Reply-To: <patchbomb.1207158829@localhost>
Date: Wed, 02 Apr 2008 10:54:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Isaku Yamahata <yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

asm/paravirt.h ends up including linux/sched.h, which pud_populate needs
for its reference to current.  Specifically include linux/sched.h for it.

In file included from /home/jeremy/hg/xen/paravirt/linux/arch/x86/mm/pgtable.c:3:
include2/asm/pgalloc.h: In function ‘pud_populate’:
include2/asm/pgalloc.h:93: error: dereferencing pointer to incomplete type
make[3]: *** [arch/x86/mm/pgtable.o] Error 1
make[2]: *** [arch/x86/mm/] Error 2
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/pgalloc.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/asm-x86/pgalloc.h b/include/asm-x86/pgalloc.h
--- a/include/asm-x86/pgalloc.h
+++ b/include/asm-x86/pgalloc.h
@@ -4,6 +4,7 @@
 #include <linux/threads.h>
 #include <linux/mm.h>		/* for struct page */
 #include <linux/pagemap.h>
+#include <linux/sched.h>
 
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>


