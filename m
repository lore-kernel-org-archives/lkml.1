Return-Path: <linux-kernel-owner+w=401wt.eu-S1163344AbXD1SBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163344AbXD1SBU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163342AbXD1SBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:01:09 -0400
Received: from ns2.suse.de ([195.135.220.15]:38984 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163351AbXD1R7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:59:03 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428758.455116000@suse.de>
In-Reply-To: <20070428758.455116000@suse.de>
To: Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: [PATCH] [14/22] x86_64: Modify discover_ebda to use virtual addresses
Message-Id: <20070428175901.747B3151CA@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:59:01 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Vivek Goyal <vgoyal@in.ibm.com>


Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/x86_64/kernel/setup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/arch/x86_64/kernel/setup.c
===================================================================
--- linux.orig/arch/x86_64/kernel/setup.c
+++ linux/arch/x86_64/kernel/setup.c
@@ -205,10 +205,10 @@ static void discover_ebda(void)
 	 * there is a real-mode segmented pointer pointing to the 
 	 * 4K EBDA area at 0x40E
 	 */
-	ebda_addr = *(unsigned short *)EBDA_ADDR_POINTER;
+	ebda_addr = *(unsigned short *)__va(EBDA_ADDR_POINTER);
 	ebda_addr <<= 4;
 
-	ebda_size = *(unsigned short *)(unsigned long)ebda_addr;
+	ebda_size = *(unsigned short *)__va(ebda_addr);
 
 	/* Round EBDA up to pages */
 	if (ebda_size == 0)
