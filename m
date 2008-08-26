Return-Path: <linux-kernel-owner+w=401wt.eu-S1753551AbYHZToR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbYHZToR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755842AbYHZTn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:43:59 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:49633 "EHLO
	camus.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735AbYHZTn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 15:43:58 -0400
From: Eric Anholt <eric@anholt.net>
To: linux-kernel@vger.kernel.org
Cc: Eric Anholt <eric@anholt.net>
Subject: [PATCH] Export kmap_atomic_pfn for DRM-GEM.
Date: Tue, 26 Aug 2008 12:43:08 -0700
Message-Id: <1219779789-8368-3-git-send-email-eric@anholt.net>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1219779789-8368-2-git-send-email-eric@anholt.net>
References: <1219779789-8368-1-git-send-email-eric@anholt.net>
 <1219779789-8368-2-git-send-email-eric@anholt.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver would like to map IO space directly for copying data in when
appropriate, to avoid CPU cache flushing for streaming writes.
kmap_atomic_pfn lets us avoid IPIs associated with ioremap for this process.

Signed-off-by: Eric Anholt <eric@anholt.net>
---
 arch/x86/mm/highmem_32.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index 165c871..d52e91d 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -137,6 +137,7 @@ void *kmap_atomic_pfn(unsigned long pfn, enum km_type type)
 
 	return (void*) vaddr;
 }
+EXPORT_SYMBOL(kmap_atomic_pfn);
 
 struct page *kmap_atomic_to_page(void *ptr)
 {
-- 
1.5.6.3

