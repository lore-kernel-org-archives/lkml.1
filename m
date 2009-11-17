Return-Path: <linux-kernel-owner+w=401wt.eu-S1754404AbZKQSR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbZKQSR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 13:17:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbZKQSRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 13:17:55 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:23567 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbZKQSRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 13:17:54 -0500
Date: Tue, 17 Nov 2009 10:17:42 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       devel@driverdev.osuosl.org
Subject: [PATCH -next] sep: fix 2 warnings
Message-Id: <20091117101742.d512100e.randy.dunlap@oracle.com>
In-Reply-To: <20091117195309.6cc3ead0.sfr@canb.auug.org.au>
References: <20091117195309.6cc3ead0.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B02E8CD.012C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warning:
drivers/staging/sep/sep_driver.c:276: warning: format '%08llx' expects type 'long long unsigned int', but argument 2 has type 'dma_addr_t'

and variable may be used uninitialized (correct):
drivers/staging/sep/sep_driver.c:1774: warning: 'error' may be used uninitialized in this function

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/sep/sep_driver.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- linux-next-20091117.orig/drivers/staging/sep/sep_driver.c
+++ linux-next-20091117/drivers/staging/sep/sep_driver.c
@@ -273,7 +273,8 @@ static dma_addr_t sep_shared_virt_to_bus
 						void *virt_address)
 {
 	dma_addr_t pa = sep->shared_bus + (virt_address - sep->shared_addr);
-	edbg("sep: virt to bus b %08llx v %p\n", pa, virt_address);
+	edbg("sep: virt to bus b %08llx v %p\n",
+		(unsigned long long)pa, virt_address);
 	return pa;
 }
 
@@ -1788,6 +1789,7 @@ static int sep_create_flow_dma_tables_ha
 	first_table_data.physical_address = 0xffffffff;
 
 	/* find the free structure for flow data */
+	error = -EINVAL;
 	flow_context_ptr = sep_find_flow_context(sep, SEP_FREE_FLOW_ID);
 	if (flow_context_ptr == NULL)
 		goto end_function;
