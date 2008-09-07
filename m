Return-Path: <linux-kernel-owner+w=401wt.eu-S1757699AbYIGW0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699AbYIGW0s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 18:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756093AbYIGWYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 18:24:19 -0400
Received: from gw.goop.org ([64.81.55.164]:39674 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755122AbYIGWYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 18:24:15 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 7 of 7] x86: always explicitly map acpi memory
X-Mercurial-Node: 6f23bad119ae2ed00f1cfc55079a1a3692423872
Message-Id: <6f23bad119ae2ed00f1c.1220826079@localhost>
In-Reply-To: <patchbomb.1220826072@localhost>
Date: Sun, 07 Sep 2008 15:21:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Xen Devel <xen-devel@lists.xensource.com>,
       Andi Kleen <andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Always map acpi tables, rather than assuming we can use the normal
linear mapping to access the acpi tables.  This is necessary in a
virtual environment where the linear mappings are to pseudo-physical
memory, but the acpi tables exist at a real physical address.  It
doesn't hurt to map in the normal non-virtual case, so just do it
unconditionally.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/acpi/boot.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -126,9 +126,6 @@
 
 	if (!phys || !size)
 		return NULL;
-
-	if (phys+size <= (max_low_pfn_mapped << PAGE_SHIFT))
-		return __va(phys);
 
 	if (prev_map)
 		early_iounmap(prev_map, prev_size);


