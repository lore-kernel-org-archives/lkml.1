Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbYJ1QGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbYJ1QGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 12:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbYJ1QGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 12:06:33 -0400
Received: from smtp-out.google.com ([216.239.45.13]:60567 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbYJ1QGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 12:06:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type;
	b=j+34MORwbCm2uC4OgFXQgYqDdI6D5w3wm5jdNt1tJDP39gxyPLhER6TV0lrGUkbN0
	kUiFdIktjvUkJQm52Y3zg==
Date: Tue, 28 Oct 2008 09:05:46 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [patch] vmemmap: warn about page_structs with remote distance
Message-ID: <alpine.DEB.1.10.0810280312390.16242@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's insufficient to simply compare node ids when warning about offnode
page_structs since it's possible to still have local affinity.

Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/sparse-vmemmap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -64,7 +64,7 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
 	unsigned long pfn = pte_pfn(*pte);
 	int actual_node = early_pfn_to_nid(pfn);
 
-	if (actual_node != node)
+	if (node_distance(actual_node, node) > LOCAL_DISTANCE)
 		printk(KERN_WARNING "[%lx-%lx] potential offnode "
 			"page_structs\n", start, end - 1);
 }
