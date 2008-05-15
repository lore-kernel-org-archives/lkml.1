Return-Path: <linux-kernel-owner+w=401wt.eu-S1757598AbYEOMYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598AbYEOMYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 08:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbYEOMYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 08:24:39 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:32615 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbYEOMYi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 08:24:38 -0400
Message-Id: <482C47B4.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Thu, 15 May 2008 13:24:52 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, "Jeremy Fitzhardinge" <jeremy@goop.org>,
       <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/xen: fix arbitrary_virt_to_machine()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While I realize that the function isn't currently being used, I still
think an obvious mistake like this should be corrected.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -60,7 +60,7 @@ xmaddr_t arbitrary_virt_to_machine(unsig
 {
 	unsigned int level;
 	pte_t *pte = lookup_address(address, &level);
-	unsigned offset = address & PAGE_MASK;
+	unsigned offset = address & (PAGE_SIZE - 1);
 
 	BUG_ON(pte == NULL);
 


