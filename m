Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933301Ab0CKRcI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 12:32:08 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35735 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638Ab0CKRcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 12:32:03 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 1/3] of/flattree: make of_fdt.h safe to unconditionally
	include.
To: devicetree-discuss@lists.ozlabs.org, benh@kernel.crashing.org,
       davem@davemloft.net, jeremy.kerr@canonical.com, monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org
Date: Thu, 11 Mar 2010 10:31:58 -0700
Message-ID: <20100311173157.4423.84971.stgit@angua>
In-Reply-To: <20100311173024.4423.53178.stgit@angua>
References: <20100311173024.4423.53178.stgit@angua>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_OF_FLATTREE is not set, then don't process the body of
linux/of_fdt.h

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 include/linux/of_fdt.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
index a1ca92c..f0fdd1f 100644
--- a/include/linux/of_fdt.h
+++ b/include/linux/of_fdt.h
@@ -57,6 +57,7 @@ struct boot_param_header {
 	__be32	dt_struct_size;		/* size of the DT structure block */
 };
 
+#if defined(CONFIG_OF_FLATTREE)
 /* TBD: Temporary export of fdt globals - remove when code fully merged */
 extern int __initdata dt_root_addr_cells;
 extern int __initdata dt_root_size_cells;
@@ -98,6 +99,7 @@ extern int early_init_dt_scan_root(unsigned long node, const char *uname,
 /* Other Prototypes */
 extern void unflatten_device_tree(void);
 extern void early_init_devtree(void *);
+#endif /* CONFIG_OF_FLATTREE */
 
 #endif /* __ASSEMBLY__ */
 #endif /* _LINUX_OF_FDT_H */

