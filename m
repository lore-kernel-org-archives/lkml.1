Return-Path: <linux-kernel-owner+w=401wt.eu-S1762871AbYCGJLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762871AbYCGJLU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 04:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761708AbYCGJHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 04:07:30 -0500
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:44221 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761012AbYCGJHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 04:07:25 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <200803071007.493903088@firstfloor.org>
In-Reply-To: <200803071007.493903088@firstfloor.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] [2/13] Make get_order(0) return 0
Message-Id: <20080307090712.8CAA21B419C@basil.firstfloor.org>
Date: Fri,  7 Mar 2008 10:07:12 +0100 (CET)
X-OriginalArrivalTime: 07 Mar 2008 09:00:42.0306 (UTC) FILETIME=[B8D94A20:01C88031]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is needed for some followup patches. Some old drivers 
(like xd.c) pass 0 to get_order and the compat wrapper for 
the mask allocator doesn't like the resulting underflow.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-generic/page.h |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/include/asm-generic/page.h
===================================================================
--- linux.orig/include/asm-generic/page.h
+++ linux/include/asm-generic/page.h
@@ -11,6 +11,9 @@ static __inline__ __attribute_const__ in
 {
 	int order;
 
+	if (size == 0)
+		return 0;
+
 	size = (size - 1) >> (PAGE_SHIFT - 1);
 	order = -1;
 	do {
