Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbYJVKbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbYJVKbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 06:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbYJVKbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 06:31:38 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:62194 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752525AbYJVKbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 06:31:38 -0400
Date: Wed, 22 Oct 2008 19:31:11 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] kernel/resource: Fix reserve_region_with_split() section mismatch.
Message-ID: <20081022103111.GA14013@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
	Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reserve_region_with_split() calls in to __reserve_region_with_split(),
which is an __init function. All callers of reserve_region_with_split()
are also __init functions, so make it __init too.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 kernel/resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 4089d12..7fec0e4 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -571,7 +571,7 @@ static void __init __reserve_region_with_split(struct resource *root,
 
 }
 
-void reserve_region_with_split(struct resource *root,
+void __init reserve_region_with_split(struct resource *root,
 		resource_size_t start, resource_size_t end,
 		const char *name)
 {
