Return-Path: <linux-kernel-owner+w=401wt.eu-S1755986AbYBHXZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbYBHXZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 18:25:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbYBHXYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 18:24:53 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:56318 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbYBHXYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 18:24:52 -0500
Date: Fri, 8 Feb 2008 15:22:44 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: arjan@infradead.org, akpm <akpm@linux-foundation.org>,
       linux-pcmcia@lists.infradead.org
Subject: [PATCH] pcmcia: fix i82092 printk format
Message-Id: <20080208152244.8aa5fdbb.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings:
linux-2.6.24-git19/drivers/pcmcia/i82092.c:650: warning: format '%lx' expects type 'long unsigned int', but argument 3 has type 'resource_size_t'
linux-2.6.24-git19/drivers/pcmcia/i82092.c:650: warning: format '%lx' expects type 'long unsigned int', but argument 4 has type 'resource_size_t'

Fix very long source line size.
Fix spacing within the printk format string.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/pcmcia/i82092.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- linux-2.6.24-git19.orig/drivers/pcmcia/i82092.c
+++ linux-2.6.24-git19/drivers/pcmcia/i82092.c
@@ -647,7 +647,9 @@ static int i82092aa_set_mem_map(struct p
 	if ( (mem->card_start > 0x3ffffff) || (region.start > region.end) ||
 	     (mem->speed > 1000) ) {
 		leave("i82092aa_set_mem_map: invalid address / speed");
-		printk("invalid mem map for socket %i : %lx to %lx with a start of %x \n",sock,region.start, region.end, mem->card_start);
+		printk("invalid mem map for socket %i: %llx to %llx with a start of %x\n",
+			sock, (unsigned long long)region.start,
+			(unsigned long long)region.end, mem->card_start);
 		return -EINVAL;
 	}
 	
