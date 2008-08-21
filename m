Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbYHUN1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbYHUN1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 09:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbYHUN1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 09:27:39 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:37758 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbYHUN1j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 09:27:39 -0400
Message-Id: <48AD89AA.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Thu, 21 Aug 2008 14:28:42 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: fix two modpost warnings in mm/init_64.c
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

early_io{re,un}map() are __init and hence can't be called from __meminit
functions.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/mm/init_64.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.27-rc4/arch/x86/mm/init_64.c	2008-08-21 15:02:41.000000000 +0200
+++ 2.6.27-rc4-x86_64-modpost-mm-init/arch/x86/mm/init_64.c	2008-08-21 11:49:44.000000000 +0200
@@ -241,7 +241,7 @@ static unsigned long __initdata table_st
 static unsigned long __meminitdata table_end;
 static unsigned long __meminitdata table_top;
 
-static __meminit void *alloc_low_page(unsigned long *phys)
+static __ref void *alloc_low_page(unsigned long *phys)
 {
 	unsigned long pfn = table_end++;
 	void *adr;
@@ -262,7 +262,7 @@ static __meminit void *alloc_low_page(un
 	return adr;
 }
 
-static __meminit void unmap_low_page(void *adr)
+static __ref void unmap_low_page(void *adr)
 {
 	if (after_bootmem)
 		return;



