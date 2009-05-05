Return-Path: <linux-kernel-owner+w=401wt.eu-S1755069AbZEEV2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbZEEV2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 17:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbZEEV2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 17:28:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55313 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996AbZEEV17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 17:27:59 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/3] Use roundown_pow_of_two() in zone_batchsize()
To: torvalds@osdl.org, akpm@linux-foundation.org, npiggin@suse.de
Cc: gerg@snapgear.com, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Date: Tue, 05 May 2009 22:26:38 +0100
Message-ID: <20090505212638.17034.10989.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use roundown_pow_of_two(N) in zone_batchsize() rather than (1 << (fls(N)-1))
as they are equivalent, and with the former it is easier to see what is going
on.

Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Lanttor Guo <lanttor.guo@freescale.com>
---

 mm/page_alloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e2f2699..8add7da 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2706,7 +2706,7 @@ static int zone_batchsize(struct zone *zone)
 	 * of pages of one half of the possible page colors
 	 * and the other with pages of the other colors.
 	 */
-	batch = (1 << (fls(batch + batch/2)-1)) - 1;
+	batch = rounddown_pow_of_two(batch + batch/2) - 1;
 
 	return batch;
 }

