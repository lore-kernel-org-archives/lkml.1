Return-Path: <linux-kernel-owner+w=401wt.eu-S966059AbXDBWth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966059AbXDBWth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 18:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966041AbXDBWrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 18:47:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966040AbXDBWqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 18:46:36 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] SLAB: Mention slab name when listing corrupt objects
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Date: Mon, 02 Apr 2007 23:46:28 +0100
Message-ID: <20070402224628.31682.67979.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mention the slab name when listing corrupt objects.  Although the function
that released the memory is mentioned, that is frequently ambiguous as such
functions often release several pieces of memory.

Signed-Off-By: David Howells <dhowells@redhat.com>
---

 mm/slab.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 57f7aa4..4cbac24 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1802,8 +1802,8 @@ static void check_poison_obj(struct kmem_cache *cachep, void *objp)
 			/* Print header */
 			if (lines == 0) {
 				printk(KERN_ERR
-					"Slab corruption: start=%p, len=%d\n",
-					realobj, size);
+					"Slab corruption: %s start=%p, len=%d\n",
+					cachep->name, realobj, size);
 				print_objinfo(cachep, objp, 0);
 			}
 			/* Hexdump the affected line */

