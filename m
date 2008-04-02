Return-Path: <linux-kernel-owner+w=401wt.eu-S1758064AbYDBOg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064AbYDBOg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 10:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757540AbYDBOgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 10:36:42 -0400
Received: from mail04.svc.cra.dublin.eircom.net ([159.134.118.20]:32579 "HELO
	mail04.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757496AbYDBOgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 10:36:41 -0400
From: Mark McLoughlin <markmc@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       xen-devel@lists.xensource.com, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 3/3] xen: Clear PG_pinned in release_{pt,pd}()
Date: Wed,  2 Apr 2008 15:36:38 +0100
Message-Id: <1207146998-14607-3-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1207146998-14607-2-git-send-email-markmc@redhat.com>
References: <1207146943.11911.1.camel@muff>
 <1207146998-14607-1-git-send-email-markmc@redhat.com>
 <1207146998-14607-2-git-send-email-markmc@redhat.com>
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
index f16b056..27ee26a 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -717,6 +717,7 @@ static void xen_release_ptpage(u32 pfn, unsigned level)
 				pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, pfn);
 			make_lowmem_page_readwrite(__va(PFN_PHYS(pfn)));
 		}
+		ClearPagePinned(page);
 	}
 }
 
-- 
1.5.4.5

