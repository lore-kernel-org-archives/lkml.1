Return-Path: <linux-kernel-owner+w=401wt.eu-S1758227AbYGBBEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbYGBBEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 21:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759521AbYGBBCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 21:02:38 -0400
Received: from gw.goop.org ([64.81.55.164]:58693 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758289AbYGBBBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 21:01:52 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 4 of 8] x86_64/setup: unconditionally populate the pgd
X-Mercurial-Node: be113d2437ec5dd245d0688ae348f39bb59f3f93
Message-Id: <be113d2437ec5dd245d0.1214955993@localhost>
In-Reply-To: <patchbomb.1214955989@localhost>
Date: Tue, 01 Jul 2008 16:46:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When allocating a new pud, unconditionally populate the pgd (why did
we bother to create a new pud if we weren't going to populate it?).

This will only happen if the pgd slot was empty, since any existing
pud will be reused.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/mm/init_64.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -549,9 +549,8 @@
 
 		last_map_addr = phys_pud_init(pud, __pa(start), __pa(next));
 		unmap_low_page(pud);
-		if (!after_bootmem)
-			pgd_populate(&init_mm, pgd_offset_k(start),
-				     __va(pud_phys));
+		pgd_populate(&init_mm, pgd_offset_k(start),
+			     __va(pud_phys));
 	}
 
 	if (!after_bootmem)


