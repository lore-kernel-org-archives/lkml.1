Return-Path: <linux-kernel-owner+w=401wt.eu-S1754444AbXKSGoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbXKSGoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 01:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbXKSGoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 01:44:06 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48045 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbXKSGoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 01:44:04 -0500
Date: Mon, 19 Nov 2007 17:44:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: paulus@samba.org
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, anton@au1.ibm.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org
Subject: [PATCH] 2.6.24-rc2-mm1 powerpc (iseries)- build failure - mm/stab.c
Message-Id: <20071119174405.7ae746f1.sfr@canb.auug.org.au>
In-Reply-To: <20071119062611.GA11135@linux.vnet.ibm.com>
References: <20071114105410.GA16846@linux.vnet.ibm.com>
	<20071119133849.bcfe52c1.sfr@canb.auug.org.au>
	<20071119062611.GA11135@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

The kernel builds fails with following error, with randconfig

  CC      arch/powerpc/mm/stab.o
arch/powerpc/mm/stab.c: In function ‘stab_initialize’:
arch/powerpc/mm/stab.c:282: error: implicit declaration of function ‘HvCall1’
arch/powerpc/mm/stab.c:282: error: ‘HvCallBaseSetASR’ undeclared (first use in this function)
arch/powerpc/mm/stab.c:282: error: (Each undeclared identifier is reported only once
arch/powerpc/mm/stab.c:282: error: for each function it appears in.)
make[1]: *** [arch/powerpc/mm/stab.o] Error 1
make: *** [arch/powerpc/mm] Error 2

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/mm/stab.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

On Mon, 19 Nov 2007 11:56:11 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
>
> Resubmitting the patch titled 
> powerpc-iseries-build-failure-mm-stabc.patch in the -mm tree.

Paulus, this should be fine for merging like above.

Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/arch/powerpc/mm/stab.c b/arch/powerpc/mm/stab.c
index 9e85bda..50448d5 100644
--- a/arch/powerpc/mm/stab.c
+++ b/arch/powerpc/mm/stab.c
@@ -20,6 +20,7 @@
 #include <asm/lmb.h>
 #include <asm/abs_addr.h>
 #include <asm/firmware.h>
+#include <asm/iseries/hv_call.h>
 
 struct stab_entry {
 	unsigned long esid_data;
-- 
1.5.3.5

