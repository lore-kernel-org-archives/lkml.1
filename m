Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbYANRoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbYANRoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 12:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbYANRoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 12:44:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:43786 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbYANRoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 12:44:10 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@osdl.org>
Subject: [PATCH 2.6.24 please] pnpacpi: print resource shortage message only once (more)
Date: Mon, 14 Jan 2008 12:43:53 -0500
User-Agent: KMail/1.9.5
Cc: "Hartkopp, Oliver (K-EFE/E)" <oliver.hartkopp@volkswagen.de>,
       linux-kernel@vger.kernel.org
References: <71A66C381173F7418BA6E78EE9E33465AC02EC@vwagwox00011.vw.vwg>
In-Reply-To: <71A66C381173F7418BA6E78EE9E33465AC02EC@vwagwox00011.vw.vwg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801141243.53513.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Wups, previous patch was ineffective in 2 cases.
    
http://bugzilla.kernel.org/show_bug.cgi?id=9535
    
Signed-off-by: Len Brown <len.brown@intel.com>
---
Thanks for noticing, Oliver!

diff --git a/drivers/pnp/pnpacpi/rsparser.c b/drivers/pnp/pnpacpi/rsparser.c
index f7b8648..6b9840c 100644
--- a/drivers/pnp/pnpacpi/rsparser.c
+++ b/drivers/pnp/pnpacpi/rsparser.c
@@ -215,6 +215,7 @@ static void pnpacpi_parse_allocated_ioresource(struct pnp_resource_table *res,
 	} else if (!warned) {
 		printk(KERN_ERR "pnpacpi: exceeded the max number of IO "
 				"resources: %d \n", PNP_MAX_PORT);
+		warned = 1;
 	}
 }
 
@@ -242,6 +243,7 @@ static void pnpacpi_parse_allocated_memresource(struct pnp_resource_table *res,
 	} else if (!warned) {
 		printk(KERN_ERR "pnpacpi: exceeded the max number of mem "
 				"resources: %d\n", PNP_MAX_MEM);
+		warned = 1;
 	}
 }
 
