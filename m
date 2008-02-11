Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008AbYBKCVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbYBKCVS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 21:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbYBKCVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 21:21:09 -0500
Received: from lixom.net ([66.141.50.11]:47857 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbYBKCVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 21:21:08 -0500
Date: Sun, 10 Feb 2008 20:22:57 -0600
From: Olof Johansson <olof@lixom.net>
To: Roland Dreier <rdreier@cisco.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       jackm@dev.mellanox.co.il
Subject: [PATCH] mlx4: fix build break
Message-ID: <20080211022257.GA26656@lixom.net>
References: <adafxw36ntm.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adafxw36ntm.fsf@cisco.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 03:16:53PM -0800, Roland Dreier wrote:

>       mlx4_core: For 64-bit systems, vmap() kernel queue buffers

Hi,

The above patch caused this to pop up on powerpc allyesconfig, looks
like a missing include file:

drivers/net/mlx4/alloc.c: In function 'mlx4_buf_alloc':
drivers/net/mlx4/alloc.c:162: error: implicit declaration of function 'vmap'
drivers/net/mlx4/alloc.c:162: error: 'VM_MAP' undeclared (first use in this function)
drivers/net/mlx4/alloc.c:162: error: (Each undeclared identifier is reported only once
drivers/net/mlx4/alloc.c:162: error: for each function it appears in.)
drivers/net/mlx4/alloc.c:162: warning: assignment makes pointer from integer without a cast
drivers/net/mlx4/alloc.c: In function 'mlx4_buf_free':
drivers/net/mlx4/alloc.c:187: error: implicit declaration of function 'vunmap'

Signed-off-by: Olof Johansson <olof@lixom.net>


diff --git a/drivers/net/mlx4/alloc.c b/drivers/net/mlx4/alloc.c
index 521dc03..75ef9d0 100644
--- a/drivers/net/mlx4/alloc.c
+++ b/drivers/net/mlx4/alloc.c
@@ -34,6 +34,7 @@
 #include <linux/slab.h>
 #include <linux/bitmap.h>
 #include <linux/dma-mapping.h>
+#include <linux/vmalloc.h>
 
 #include "mlx4.h"
 
