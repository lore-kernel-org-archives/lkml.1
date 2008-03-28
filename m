Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbYC1QmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbYC1QmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 12:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbYC1Qlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 12:41:52 -0400
Received: from mail06.svc.cra.dublin.eircom.net ([159.134.118.22]:33957 "HELO
	mail06.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750961AbYC1Qlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 12:41:51 -0400
From: Mark McLoughlin <markmc@redhat.com>
To: jeremy@goop.org
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, xen-devel@lists.xensource.com,
       Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 3/3] xen: Clear PG_pinned in release_{pte,pmd}()
Date: Fri, 28 Mar 2008 16:38:17 +0000
Message-Id: <1206722297-11763-4-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1206722297-11763-3-git-send-email-markmc@redhat.com>
References: <1206722297-11763-1-git-send-email-markmc@redhat.com>
 <1206722297-11763-2-git-send-email-markmc@redhat.com>
 <1206722297-11763-3-git-send-email-markmc@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't currently clear PG_pinned in release_pt(),
probably because the page is to be freed anyway,
but it jumps out as an obvious gap in the logic
so add clear the flag for consistency sake.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 arch/x86/xen/enlighten.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 0ce225f..8c5ff24 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -719,6 +719,7 @@ static void xen_release_ptpage(u32 pfn, unsigned level)
 				pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, pfn);
 			make_lowmem_page_readwrite(__va(PFN_PHYS(pfn)));
 		}
+		ClearPagePinned(page);
 	}
 }
 
-- 
1.5.4.1

