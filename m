Return-Path: <linux-kernel-owner+w=401wt.eu-S1761618AbYBLJmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761618AbYBLJmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 04:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758572AbYBLJmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 04:42:11 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:45298 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757245AbYBLJmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 04:42:09 -0500
Date: Tue, 12 Feb 2008 15:12:07 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] 2.6.25-rc1 ml4x network driver build failure
Message-ID: <20080212094207.GA19427@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 2.6.25-rc1 kernel build fails on the powerpc with the error

drivers/net/mlx4/alloc.c: In function ‘mlx4_buf_alloc’:
drivers/net/mlx4/alloc.c:162: error: implicit declaration of function ‘vmap’
drivers/net/mlx4/alloc.c:162: error: ‘VM_MAP’ undeclared (first use in this function)
drivers/net/mlx4/alloc.c:162: error: (Each undeclared identifier is reported only once
drivers/net/mlx4/alloc.c:162: error: for each function it appears in.)
drivers/net/mlx4/alloc.c:162: warning: assignment makes pointer from integer without a cast
drivers/net/mlx4/alloc.c: In function ‘mlx4_buf_free’:
drivers/net/mlx4/alloc.c:187: error: implicit declaration of function ‘vunmap’
make[3]: *** [drivers/net/mlx4/alloc.o] Error 1
make[2]: *** [drivers/net/mlx4] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2

I have tested the patch for the build failure.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--
--- linux-2.6.25-rc1/drivers/net/mlx4/alloc.c	2008-02-11 03:48:14.000000000 +0530
+++ linux-2.6.25-rc1/drivers/net/mlx4/~alloc.c	2008-02-12 14:43:46.000000000 +0530
@@ -34,6 +34,7 @@
 #include <linux/slab.h>
 #include <linux/bitmap.h>
 #include <linux/dma-mapping.h>
+#include <linux/vmalloc.h>
 
 #include "mlx4.h"
 
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
