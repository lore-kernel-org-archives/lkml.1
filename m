Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab0BVP6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 10:58:49 -0500
Received: from mail-px0-f184.google.com ([209.85.216.184]:44262 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab0BVP6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 10:58:48 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 1/2] of/flattree: make of_fdt.h safe to unconditionally
	include.
To: devicetree-discuss@lists.ozlabs.org, monstr@monstr.eu,
       linux-kernel@vger.kernel.org, jeremy.kerr@canonical.com
Date: Mon, 22 Feb 2010 08:50:54 -0700
Message-ID: <20100222155053.3604.45279.stgit@angua>
In-Reply-To: <20100222154816.3604.67114.stgit@angua>
References: <20100222154816.3604.67114.stgit@angua>
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

