Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbYJERWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbYJERWf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 13:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbYJERW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 13:22:26 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:19124 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286AbYJERWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 13:22:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=weadxDgLN15pX0CGrc05HXs/tY83kXoWVBJsnG4A9hQDjuUKzogt5IWv2mKIbwutLh
         LfJxQNMmq/xk4Jv+mdmYeHMUJIELZ6HyU3qOVClOWGIJ6xw0jCf7841VGNN1jZI7J86s
         gFOcn+dzWEq1Qpt0qtrTaUA8Pe5RudbM5uEyw=
Date: Sun, 5 Oct 2008 19:22:30 +0200
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: [PATCH -tip] kmemcheck: use set_memory_4k() on x86_64 only
Message-ID: <20081005172230.GA24825@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5bce9b1674e84ff36ba8f5a390b2ad30cd42b29a Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Wed, 1 Oct 2008 18:36:42 +0200
Subject: [PATCH] kmemcheck: use set_memory_4k() on x86_64 only

x86_32 already disables PSE capabilities and is fine. We need this to
avoid the BUG in cache-flushing SMP call.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/mm/kmemcheck/kmemcheck.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/kmemcheck/kmemcheck.c b/arch/x86/mm/kmemcheck/kmemcheck.c
index 5a08a70..d649aa7 100644
--- a/arch/x86/mm/kmemcheck/kmemcheck.c
+++ b/arch/x86/mm/kmemcheck/kmemcheck.c
@@ -295,7 +295,9 @@ void kmemcheck_hide_pages(struct page *p, unsigned int n)
 {
 	unsigned int i;
 
+#ifdef CONFIG_X86_64
 	set_memory_4k((unsigned long) page_address(p), n);
+#endif
 
 	for (i = 0; i < n; ++i) {
 		unsigned long address;
-- 
1.5.5.1

