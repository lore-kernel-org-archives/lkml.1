Return-Path: <linux-kernel-owner+w=401wt.eu-S1751913AbYJYSZD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbYJYSZD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 14:25:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbYJYSYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 14:24:53 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:29997 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbYJYSYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 14:24:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=pFKakl45VuY+fI+05wNzcZsnQMZAnSWer4mtwKw43t+LMwN8Na5j//LgmR4GV3ojZk
         LnZ95UW1rZmpJjTQBSxWRdNVJ586ZuO1IMnKAccPa8WuH2A6kI4hCFzH+xgckC5zKQSz
         NQ6BrXS9tLUSVluea8pxJyMlDMZyZvhpr6knk=
Date: Sat, 25 Oct 2008 20:24:33 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: convert highmem macros to functions
Message-ID: <20081025182428.GB10932@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

convert kmap_init, permanent_kmaps_init, set_highmem_pages_init macros
defined when !CONFIG_HIGHMEM to functions

supresses following warning from gcc:
arch/x86/mm/init_32.c: In function 'pagetable_init':
arch/x86/mm/init_32.c:516: warning: unused variable 'pgd_base'

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/init_32.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 8396868..d5dfdc4 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -436,9 +436,9 @@ static void __init set_highmem_pages_init(void)
 #endif /* !CONFIG_NUMA */
 
 #else
-# define kmap_init()				do { } while (0)
-# define permanent_kmaps_init(pgd_base)		do { } while (0)
-# define set_highmem_pages_init()	do { } while (0)
+static inline void kmap_init(void) {}
+static inline void permanent_kmaps_init(pgd_t *pgd_base) {}
+static inline void set_highmem_pages_init(void) {}
 #endif /* CONFIG_HIGHMEM */
 
 void __init native_pagetable_setup_start(pgd_t *base)
-- 
1.5.6.4

