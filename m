Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbYAQVl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbYAQVl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:41:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757383AbYAQVlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:41:18 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:44740 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757278AbYAQVlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:41:17 -0500
Date: Thu, 17 Jan 2008 16:40:47 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 16/20] UML - Use of a public MAC is a warning, not an error
Message-ID: <20080117214047.GA6767@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Downgrade one of the MAC validity checks.  If it's one that could be
possibly assigned to a physical NIC, then nothing will break.  So,
emit a warning in this case, but keep the requested MAC.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/drivers/net_kern.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

Index: linux-2.6-git/arch/um/drivers/net_kern.c
===================================================================
--- linux-2.6-git.orig/arch/um/drivers/net_kern.c	2008-01-02 13:16:19.000000000 -0500
+++ linux-2.6-git/arch/um/drivers/net_kern.c	2008-01-02 15:37:02.000000000 -0500
@@ -318,7 +318,7 @@ static void setup_etheraddr(char *str, u
 	if (str == NULL)
 		goto random;
 
-	for (i = 0;i < 6; i++) {
+	for (i = 0; i < 6; i++) {
 		addr[i] = simple_strtoul(str, &end, 16);
 		if ((end == str) ||
 		   ((*end != ':') && (*end != ',') && (*end != '\0'))) {
@@ -343,14 +343,13 @@ static void setup_etheraddr(char *str, u
 	}
 	if (!is_local_ether_addr(addr)) {
 		printk(KERN_WARNING
-		       "Warning: attempt to assign a globally valid ethernet "
+		       "Warning: Assigning a globally valid ethernet "
 		       "address to a device\n");
-		printk(KERN_WARNING "You should better enable the 2nd "
-		       "rightmost bit in the first byte of the MAC,\n");
+		printk(KERN_WARNING "You should set the 2nd rightmost bit in "
+		       "the first byte of the MAC,\n");
 		printk(KERN_WARNING "i.e. %02x:%02x:%02x:%02x:%02x:%02x\n",
 		       addr[0] | 0x02, addr[1], addr[2], addr[3], addr[4],
 		       addr[5]);
-		goto random;
 	}
 	return;
 
