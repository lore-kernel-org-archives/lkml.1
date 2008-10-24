Return-Path: <linux-kernel-owner+w=401wt.eu-S1757057AbYJXBP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057AbYJXBP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 21:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751015AbYJXBPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 21:15:49 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:12765 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbYJXBPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 21:15:48 -0400
Date: Thu, 23 Oct 2008 18:14:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>,
       torvalds <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: [PATCH] PCI hotplug printk format
Message-Id: <20081023181455.336e5d03.randy.dunlap@oracle.com>
In-Reply-To: <20081023213637.eff9b414.sfr@canb.auug.org.au>
References: <20081023213637.eff9b414.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
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

I made this patch for linux-next, but now mainline has this same code/warning.


From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warning:

linux-next-20081023/drivers/pci/hotplug/acpiphp_ibm.c:207: warning: format '%08lx' expects type 'long unsigned int', but argument 3 has type 'long long unsigned int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/pci/hotplug/acpiphp_ibm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20081023.orig/drivers/pci/hotplug/acpiphp_ibm.c
+++ linux-next-20081023/drivers/pci/hotplug/acpiphp_ibm.c
@@ -204,7 +204,7 @@ static int ibm_set_attention_status(stru
 		err("APLS evaluation failed:  0x%08x\n", stat);
 		return -ENODEV;
 	} else if (!rc) {
-		err("APLS method failed:  0x%08lx\n", rc);
+		err("APLS method failed:  0x%08llx\n", rc);
 		return -ERANGE;
 	}
 	return 0;
