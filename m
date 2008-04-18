Return-Path: <linux-kernel-owner+w=401wt.eu-S1753504AbYDRL0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbYDRL0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 07:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbYDRL0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 07:26:40 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:57519 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbYDRL0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 07:26:40 -0400
Date: Fri, 18 Apr 2008 16:56:34 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, apw@shadowen.org
Subject: [PATCH] 2.6.25-mm1 - Build Failure with PWRficient onchip memory controller driver
Message-ID: <20080418112634.GA29891@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The 2.6.25-mm1 kernel allyesconfig build fails on the powerpc

drivers/edac/pasemi_edac.c: In function ‘pasemi_edac_init’:
drivers/edac/pasemi_edac.c:288: error: implicit declaration of function ‘opstate_init’
drivers/edac/pasemi_edac.c: In function ‘__check_edac_op_state’:
drivers/edac/pasemi_edac.c:304: error: ‘edac_op_state’ undeclared (first use in this function)
drivers/edac/pasemi_edac.c:304: error: (Each undeclared identifier is reported only once
drivers/edac/pasemi_edac.c:304: error: for each function it appears in.)
drivers/edac/pasemi_edac.c: At top level:
drivers/edac/pasemi_edac.c:304: error: ‘edac_op_state’ undeclared here (not in a function)
make[2]: *** [drivers/edac/pasemi_edac.o] Error 1
make[1]: *** [drivers/edac] Error 2
make: *** [drivers] Error 2

I have only build tested the patch.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---
--- linux-2.6.25/drivers/edac/pasemi_edac.c	2008-04-18 16:18:27.000000000 +0530
+++ linux-2.6.25/drivers/edac/~pasemi_edac.c	2008-04-18 16:18:36.000000000 +0530
@@ -26,6 +26,7 @@
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
+#include <linux/edac.h>
 #include "edac_core.h"
 
 #define MODULE_NAME "pasemi_edac"
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
