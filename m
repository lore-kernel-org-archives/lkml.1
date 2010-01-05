Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657Ab0AEOQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab0AEOQB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 09:16:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754609Ab0AEOPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 09:15:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754587Ab0AEONh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 09:13:37 -0500
From: Gleb Natapov <gleb@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org
Subject: [PATCH v3 05/12] Export __get_user_pages_fast.
Date: Tue,  5 Jan 2010 16:12:47 +0200
Message-Id: <1262700774-1808-6-git-send-email-gleb@redhat.com>
In-Reply-To: <1262700774-1808-1-git-send-email-gleb@redhat.com>
References: <1262700774-1808-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM will use it to try and find a page without falling back to slow
gup. That is why get_user_pages_fast() is not enough.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 arch/x86/mm/gup.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index 71da1bc..cea0dfe 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -8,6 +8,7 @@
 #include <linux/mm.h>
 #include <linux/vmstat.h>
 #include <linux/highmem.h>
+#include <linux/module.h>
 
 #include <asm/pgtable.h>
 
@@ -274,6 +275,7 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 
 	return nr;
 }
+EXPORT_SYMBOL_GPL(__get_user_pages_fast);
 
 /**
  * get_user_pages_fast() - pin user pages in memory
-- 
1.6.5

