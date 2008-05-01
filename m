Return-Path: <linux-kernel-owner+w=401wt.eu-S1758857AbYEAJ7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857AbYEAJ7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 05:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbYEAJ7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 05:59:13 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:53804 "EHLO WNmonitoring"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751571AbYEAJ7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 05:59:12 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de, hpa@zytor.com
Subject: [PATCH 2/2] x86_64: use PAGE_OFFSET in dump_pagetables
Date: Thu,  1 May 2008 11:58:19 +0200
Message-Id: <1209635899-23018-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1209635899-23018-1-git-send-email-jirislaby@gmail.com>
References: <1209635899-23018-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PAGE_OFFSET macro instead of using 0xffff810000000000UL directly.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: tglx@linutronix.de
Cc: mingo@redhat.com
Cc: hpa@zytor.com
---
 arch/x86/mm/dump_pagetables.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index 6791b83..6f8e3fe 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -42,7 +42,7 @@ static struct addr_marker address_markers[] = {
 	{ 0, "User Space" },
 #ifdef CONFIG_X86_64
 	{ 0x8000000000000000UL, "Kernel Space" },
-	{ 0xffff810000000000UL, "Low Kernel Mapping" },
+	{ PAGE_OFFSET,		"Low Kernel Mapping" },
 	{ VMALLOC_START,        "vmalloc() Area" },
 	{ VMEMMAP_START,        "Vmemmap" },
 	{ __START_KERNEL_map,   "High Kernel Mapping" },
-- 
1.5.4.5

