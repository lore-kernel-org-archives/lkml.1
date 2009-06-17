Return-Path: <linux-kernel-owner+w=401wt.eu-S1764684AbZFQEHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764684AbZFQEHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 00:07:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbZFQEG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 00:06:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:41869 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbZFQEG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 00:06:57 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, andi@firstfloor.org, hpa@zytor.com, tglx@linutronix.de
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/6] x86: make pcpu_chunk_addr_search() matching stricter
Date: Wed, 17 Jun 2009 13:04:31 +0900
Message-Id: <1245211476-27015-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1245211476-27015-1-git-send-email-tj@kernel.org>
References: <1245211476-27015-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 04:04:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The @addr passed into pcpu_chunk_addr_search() is unit0 based address
and thus should be matched inside unit0 area.  Currently, when it uses
chunk size when determining whether the address falls in the first
chunk.  Addresses in unitN where N>0 shouldn't be passed in anyway, so
this doesn't cause any malfunction but fix it for consistency.

[ Impact: mostly cleanup ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 mm/percpu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index b149845..19dd83b 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -290,7 +290,7 @@ static struct pcpu_chunk *pcpu_chunk_addr_search(void *addr)
 	void *first_start = pcpu_first_chunk->vm->addr;
 
 	/* is it in the first chunk? */
-	if (addr >= first_start && addr < first_start + pcpu_chunk_size) {
+	if (addr >= first_start && addr < first_start + pcpu_unit_size) {
 		/* is it in the reserved area? */
 		if (addr < first_start + pcpu_reserved_chunk_limit)
 			return pcpu_reserved_chunk;
-- 
1.6.0.2

