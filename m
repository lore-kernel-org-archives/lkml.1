Return-Path: <linux-kernel-owner+w=401wt.eu-S1764557AbYA3TOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764557AbYA3TOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 14:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbYA3TOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 14:14:14 -0500
Received: from relay1.sgi.com ([192.48.171.29]:52792 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754142AbYA3TON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:14:13 -0500
Date: Wed, 30 Jan 2008 11:14:12 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Robin Holt <holt@sgi.com>
cc: Andrea Arcangeli <andrea@qumranet.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, Nick Piggin <npiggin@suse.de>,
       kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 1/6] mmu_notifier: Core code
In-Reply-To: <20080130180207.GU26420@sgi.com>
Message-ID: <Pine.LNX.4.64.0801301113350.27491@schroedinger.engr.sgi.com>
References: <20080130022909.677301714@sgi.com> <20080130022944.236370194@sgi.com>
 <20080130180207.GU26420@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok. So I added the following patch:

---
 include/linux/mmu_notifier.h |    1 +
 mm/mmu_notifier.c            |   12 ++++++++++++
 2 files changed, 13 insertions(+)

Index: linux-2.6/include/linux/mmu_notifier.h
===================================================================
--- linux-2.6.orig/include/linux/mmu_notifier.h	2008-01-30 11:09:06.000000000 -0800
+++ linux-2.6/include/linux/mmu_notifier.h	2008-01-30 11:10:38.000000000 -0800
@@ -146,6 +146,7 @@ static inline void mmu_notifier_head_ini
 
 extern void mmu_rmap_notifier_register(struct mmu_rmap_notifier *mrn);
 extern void mmu_rmap_notifier_unregister(struct mmu_rmap_notifier *mrn);
+extern void mmu_rmap_export_page(struct page *page);
 
 extern struct hlist_head mmu_rmap_notifier_list;
 
Index: linux-2.6/mm/mmu_notifier.c
===================================================================
--- linux-2.6.orig/mm/mmu_notifier.c	2008-01-30 11:09:01.000000000 -0800
+++ linux-2.6/mm/mmu_notifier.c	2008-01-30 11:12:10.000000000 -0800
@@ -99,3 +99,15 @@ void mmu_rmap_notifier_unregister(struct
 }
 EXPORT_SYMBOL(mmu_rmap_notifier_unregister);
 
+/*
+ * Export a page.
+ *
+ * Pagelock must be held.
+ * Must be called before a page is put on an external rmap.
+ */
+void mmu_rmap_export_page(struct page *page)
+{
+	BUG_ON(!PageLocked(page));
+	SetPageExternalRmap(page);
+}
+EXPORT_SYMBOL(mmu_rmap_export_page);

