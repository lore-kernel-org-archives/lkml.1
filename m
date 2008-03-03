Return-Path: <linux-kernel-owner+w=401wt.eu-S1761455AbYCCDem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761455AbYCCDem (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 22:34:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756559AbYCCDeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 22:34:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:38102 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756831AbYCCDea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 22:34:30 -0500
Date: Mon, 3 Mar 2008 04:34:28 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Jack Steiner <steiner@sgi.com>, akpm@linux-foundation.org,
       Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] mmu notifiers #v8
Message-ID: <20080303033428.GD3301@wotan.suse.de>
References: <20080219084357.GA22249@wotan.suse.de> <20080219135851.GI7128@v2.random> <20080219231157.GC18912@wotan.suse.de> <20080220010941.GR7128@v2.random> <20080220103942.GU7128@v2.random> <20080221045430.GC15215@wotan.suse.de> <20080221144023.GC9427@v2.random> <20080221161028.GA14220@sgi.com> <20080227192610.GF28483@v2.random> <20080302155457.GK8091@v2.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080302155457.GK8091@v2.random>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 02, 2008 at 04:54:57PM +0100, Andrea Arcangeli wrote:
> Difference between #v7 and #v8:

This one on top of the previous patch

[patch] mmu-v8: typesafe

Move definition of struct mmu_notifier and struct mmu_notifier_ops under
CONFIG_MMU_NOTIFIER to ensure they doesn't get dereferenced when they
don't make sense.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
Index: linux-2.6/include/linux/mmu_notifier.h
===================================================================
--- linux-2.6.orig/include/linux/mmu_notifier.h
+++ linux-2.6/include/linux/mmu_notifier.h
@@ -3,8 +3,12 @@
 
 #include <linux/list.h>
 #include <linux/spinlock.h>
+#include <linux/mm_types.h>
 
 struct mmu_notifier;
+struct mmu_notifier_ops;
+
+#ifdef CONFIG_MMU_NOTIFIER
 
 struct mmu_notifier_ops {
 	/*
@@ -53,10 +57,6 @@ struct mmu_notifier {
 	const struct mmu_notifier_ops *ops;
 };
 
-#ifdef CONFIG_MMU_NOTIFIER
-
-#include <linux/mm_types.h>
-
 static inline int mm_has_notifiers(struct mm_struct *mm)
 {
 	return unlikely(!hlist_empty(&mm->mmu_notifier_list));
