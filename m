Return-Path: <linux-kernel-owner+w=401wt.eu-S1758428AbXKNMMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428AbXKNMMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 07:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754881AbXKNMMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 07:12:25 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:36690 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbXKNMMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 07:12:24 -0500
Date: Wed, 14 Nov 2007 16:24:10 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, anton@au1.ibm.com, linuxppc-dev@ozlabs.org,
       paulus@samba.org, apw@shadowen.org
Subject: [PATCH] 2.6.24-rc2-mm1 powerpc (iseries)- build failure - mm/stab.c
Message-ID: <20071114105410.GA16846@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

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
--
--- linux-2.6.24-rc2/arch/powerpc/mm/stab.c	2007-11-14 05:22:55.000000000 -0500
+++ linux-2.6.24-rc2/arch/powerpc/mm/~stab.c	2007-11-14 05:23:18.000000000 -0500
@@ -21,6 +21,10 @@
 #include <asm/abs_addr.h>
 #include <asm/firmware.h>
 
+#ifdef CONFIG_PPC_ISERIES
+#include <asm/iseries/hv_call.h>
+#endif /* CONFIG_PPC_ISERIES */
+
 struct stab_entry {
 	unsigned long esid_data;
 	unsigned long vsid_data;

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.

