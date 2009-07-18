Return-Path: <linux-kernel-owner+w=401wt.eu-S1758179AbZGRK66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179AbZGRK66 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 06:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758165AbZGRK65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 06:58:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:46961 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbZGRK65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 06:58:57 -0400
Date: Sat, 18 Jul 2009 10:57:35 GMT
From: tip-bot for Mel Gorman <mel@csn.ul.ie>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, mel@csn.ul.ie, davem@davemloft.net,
       akpm@linux-foundation.org, htd@fancy-poultry.org, tglx@linutronix.de,
       kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, mel@csn.ul.ie, davem@davemloft.net,
       akpm@linux-foundation.org, htd@fancy-poultry.org, tglx@linutronix.de,
       kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org, mingo@elte.hu
In-Reply-To: <1247656992-19846-3-git-send-email-mel@csn.ul.ie>
References: <1247656992-19846-3-git-send-email-mel@csn.ul.ie>
Subject: [tip:tracing/urgent] profile: Suppress warning about large allocations when profile=1 is specified
Message-ID: <tip-e5d490b252423605a77c54b2e35b10ea663763df@git.kernel.org>
Git-Commit-ID: e5d490b252423605a77c54b2e35b10ea663763df
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 18 Jul 2009 10:57:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e5d490b252423605a77c54b2e35b10ea663763df
Gitweb:     http://git.kernel.org/tip/e5d490b252423605a77c54b2e35b10ea663763df
Author:     Mel Gorman <mel@csn.ul.ie>
AuthorDate: Wed, 15 Jul 2009 12:23:11 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 18 Jul 2009 12:55:28 +0200

profile: Suppress warning about large allocations when profile=1 is specified

When profile= is used, a large buffer is allocated early at
boot. This can be larger than what the page allocator can
provide so it prints a warning. However, the caller is able to
handle the situation so this patch suppresses the warning.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Cc: Heinz Diehl <htd@fancy-poultry.org>
Cc: David Miller <davem@davemloft.net>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <1247656992-19846-3-git-send-email-mel@csn.ul.ie>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/profile.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/profile.c b/kernel/profile.c
index 69911b5..419250e 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -117,11 +117,12 @@ int __ref profile_init(void)
 
 	cpumask_copy(prof_cpu_mask, cpu_possible_mask);
 
-	prof_buffer = kzalloc(buffer_bytes, GFP_KERNEL);
+	prof_buffer = kzalloc(buffer_bytes, GFP_KERNEL|__GFP_NOWARN);
 	if (prof_buffer)
 		return 0;
 
-	prof_buffer = alloc_pages_exact(buffer_bytes, GFP_KERNEL|__GFP_ZERO);
+	prof_buffer = alloc_pages_exact(buffer_bytes,
+					GFP_KERNEL|__GFP_ZERO|__GFP_NOWARN);
 	if (prof_buffer)
 		return 0;
 
