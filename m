Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbYKJFg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbYKJFg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 00:36:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbYKJFgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 00:36:46 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:4463 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbYKJFgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 00:36:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Mst7syD3xcawQ2K1IhG22gp1QExHexH4zVilvpZ9HVcZOZVMHd0tn9+tta3TNfdfsa
         BUUhRws/vkPnHg4E4WQRQYCLfhAQTPm9eefJw+UjLE2ZZxPr0E8n7WbO1wkXEr51d3mW
         NlglObmIBZCecIiMx6Av7HT4kljr3obvqhWrU=
Subject: [PATCH 1/3] lib: fix sparse shadowed variable warning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 09 Nov 2008 21:36:42 -0800
Message-Id: <1226295402.5478.11.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pos is always set before being used, no need to declare a
second one inside the if() block.

lib/prio_heap.c:34:7: warning: symbol 'pos' shadows an earlier one
lib/prio_heap.c:30:6: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 lib/prio_heap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/prio_heap.c b/lib/prio_heap.c
index 471944a..a7af6f8 100644
--- a/lib/prio_heap.c
+++ b/lib/prio_heap.c
@@ -31,7 +31,7 @@ void *heap_insert(struct ptr_heap *heap, void *p)
 
 	if (heap->size < heap->max) {
 		/* Heap insertion */
-		int pos = heap->size++;
+		pos = heap->size++;
 		while (pos > 0 && heap->gt(p, ptrs[(pos-1)/2])) {
 			ptrs[pos] = ptrs[(pos-1)/2];
 			pos = (pos-1)/2;
-- 
1.6.0.3.866.gc189b


