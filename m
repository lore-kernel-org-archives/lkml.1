Return-Path: <linux-kernel-owner+w=401wt.eu-S1760760AbXJXWYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760760AbXJXWYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 18:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757304AbXJXWY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 18:24:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755020AbXJXWY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 18:24:26 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Christoph Lameter <clameter@sgi.com>,
       glommer@gmail.com, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH] make sure init_mm is included
Date: Wed, 24 Oct 2007 16:39:34 -0300
Message-Id: <11932547743288-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

mm/sparse-vmemmap.c uses init_mm in some places. However, it
is not present in any of the headers currently included in the file.

init_mm is defined as extern in sched.h, so we add it to the headers list

Up to now, this problem was masked by the fact that functions like
set_pte_at() and pmd_populate_kernel() are usually macros that expand
to simpler variants that does not use the first parameter at all.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
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

