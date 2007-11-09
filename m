Return-Path: <linux-kernel-owner+w=401wt.eu-S1758360AbXKIV26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360AbXKIV26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 16:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757442AbXKIV2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 16:28:34 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757402AbXKIV2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 16:28:32 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, zach@vmware.com,
       jun.nakajima@intel.com, Glauber de Oliveira Costa <gcosta@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 1/24] mm/sparse-vmemmap.c: make sure init_mm is included
Date: Fri,  9 Nov 2007 16:42:42 -0200
Message-Id: <11946337933104-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11946337851964-git-send-email-gcosta@redhat.com>
References: <11946337851964-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

mm/sparse-vmemmap.c uses init_mm in some places.  However, it is not
present in any of the headers currently included in the file.

init_mm is defined as extern in sched.h, so we add it to the headers list

Up to now, this problem was masked by the fact that functions like
set_pte_at() and pmd_populate_kernel() are usually macros that expand to
simpler variants that does not use the first parameter at all.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 mm/sparse-vmemmap.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index d3b718b..22620f6 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/vmalloc.h>
+#include <linux/sched.h>
 #include <asm/dma.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
-- 
1.4.4.2

