Return-Path: <linux-kernel-owner+w=401wt.eu-S1753003AbYHTR4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003AbYHTR4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 13:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292AbYHTRzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 13:55:49 -0400
Received: from toronto-hs-216-138-233-67.s-ip.magma.ca ([216.138.233.67]:45694
	"HELO yow.seanm.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753765AbYHTRzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 13:55:48 -0400
Date: Wed, 20 Aug 2008 13:55:51 -0400
From: Sean MacLennan <smaclennan@pikatech.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Section mismatch contig_page_data and bootmem_node_data
Message-ID: <20080820135551.74911cb3@lappy.seanm.ca>
Organization: PIKA
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
X-Message-Flag: Warning: This message may contain actual content.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_NEED_MULTIPLE_NODES is *not* set, then you get a section
mismatch in reference from the variable contig_page_data to the
variable __initdata bootmem_node_data.

The simple solution is to just remove the __initdata from
bootmem_node_data. We could also put an ifdef around the __initdata.

Signed-off-by: Sean MacLennan <smaclennan@pikatech.com>
---
diff --git a/mm/bootmem.c b/mm/bootmem.c
index e023c68..a968ae2 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -31,7 +31,7 @@ unsigned long max_pfn;
 unsigned long saved_max_pfn;
 #endif
 
-bootmem_data_t bootmem_node_data[MAX_NUMNODES] __initdata;
+bootmem_data_t bootmem_node_data[MAX_NUMNODES];
 
 static struct list_head bdata_list __initdata = LIST_HEAD_INIT(bdata_list);
 
