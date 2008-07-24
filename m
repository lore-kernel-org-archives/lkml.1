Return-Path: <linux-kernel-owner+w=401wt.eu-S1752767AbYGXDm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbYGXDm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 23:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbYGXDms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 23:42:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43876
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751237AbYGXDmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 23:42:47 -0400
Date: Wed, 23 Jul 2008 20:42:47 -0700 (PDT)
Message-Id: <20080723.204247.114065226.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: sparclinux@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
       lomp0101@gmx.net, linux-kernel@vger.kernel.org, hannes@saeurebad.de
Subject: Re: [Bug 11046] New: Kernel bug in mm/bootmem.c on Sparc machines
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080723203836.e0c14568.akpm@linux-foundation.org>
References: <20080706132049.4019e09f.akpm@linux-foundation.org>
	<20080723.202533.114601491.davem@davemloft.net>
	<20080723203836.e0c14568.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 23 Jul 2008 20:38:36 -0700

> So if we're going to change it in 2.6.26, we'll need a separate patch.

Here is the 2.6.26 version:

bootmem: Allow zero length reserve and free.

It's either this or all the call sites explicitly check
when such a case is possible and sometimes expected.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/mm/bootmem.c b/mm/bootmem.c
index 8d9f60e..e540f7a 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -153,7 +153,8 @@ static void __init reserve_bootmem_core(bootmem_data_t *bdata,
 	unsigned long sidx, eidx;
 	unsigned long i;
 
-	BUG_ON(!size);
+	if (!size)
+		return;
 
 	/* out of range */
 	if (addr + size < bdata->node_boot_start ||
@@ -187,7 +188,8 @@ static void __init free_bootmem_core(bootmem_data_t *bdata, unsigned long addr,
 	unsigned long sidx, eidx;
 	unsigned long i;
 
-	BUG_ON(!size);
+	if (!size)
+		return;
 
 	/* out range */
 	if (addr + size < bdata->node_boot_start ||
