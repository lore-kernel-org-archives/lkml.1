Return-Path: <linux-kernel-owner+w=401wt.eu-S1757260AbYA1WGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260AbYA1WGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbYA1WGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:06:13 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52282 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752534AbYA1WGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:06:12 -0500
Date: Mon, 28 Jan 2008 14:06:10 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, Nick Piggin <npiggin@suse.de>,
       kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 1/6] mmu_notifier: Core code
In-Reply-To: <20080128202923.609249585@sgi.com>
Message-ID: <Pine.LNX.4.64.0801281405250.13963@schroedinger.engr.sgi.com>
References: <20080128202840.974253868@sgi.com> <20080128202923.609249585@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmu core: Need to use hlist_del

Wrong type of list del in mmu_notifier_release()

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/mmu_notifier.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/mm/mmu_notifier.c
===================================================================
--- linux-2.6.orig/mm/mmu_notifier.c	2008-01-28 14:02:18.000000000 -0800
+++ linux-2.6/mm/mmu_notifier.c	2008-01-28 14:02:30.000000000 -0800
@@ -23,7 +23,7 @@ void mmu_notifier_release(struct mm_stru
 					  &mm->mmu_notifier.head, hlist) {
 			if (mn->ops->release)
 				mn->ops->release(mn, mm);
-			hlist_del(&mn->hlist);
+			hlist_del_rcu(&mn->hlist);
 		}
 		rcu_read_unlock();
 		synchronize_rcu();

