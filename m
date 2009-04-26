Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbZDZT5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbZDZT5S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 15:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbZDZT5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 15:57:04 -0400
Received: from smtp-out.google.com ([216.239.45.13]:9708 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864AbZDZT5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 15:57:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=S0000UPPK7irRg1WeXC937/tXJ7Nt8PZ08XnVLN22FttEnv6T1qEAvvpmvSTJztvj
	Al8cj6AIqzmBNZOGkbO8Q==
Date: Sun, 26 Apr 2009 12:56:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: [patch] slqb: enforce MAX_ORDER
Message-ID: <alpine.DEB.2.00.0904261255520.18988@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Slabs may not be allocated at MAX_ORDER or higher.

Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/slqb.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/slqb.c b/mm/slqb.c
--- a/mm/slqb.c
+++ b/mm/slqb.c
@@ -872,6 +872,7 @@ __setup("slqb_debug", setup_slqb_debug);
 static int __init setup_slqb_min_order(char *str)
 {
 	get_option(&str, &slqb_min_order);
+	slqb_min_order = min(slqb_min_order, MAX_ORDER - 1);
 
 	return 1;
 }
@@ -1840,8 +1841,8 @@ static int calculate_order(int size)
 	 * This size cannot fit in order-1. Allow bigger orders, but
 	 * forget about trying to save space.
 	 */
-	order = slab_order(size, MAX_ORDER, 0);
-	if (order <= MAX_ORDER)
+	order = slab_order(size, MAX_ORDER - 1, 0);
+	if (order < MAX_ORDER)
 		return order;
 
 	return -ENOSYS;
