Return-Path: <linux-kernel-owner+w=401wt.eu-S933257AbXC0QyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933257AbXC0QyG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 12:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933271AbXC0QyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 12:54:06 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:47097 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933257AbXC0QyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 12:54:03 -0400
Subject: Re: 2.6.21-rc5-mm1
From: Badari Pulavarty <pbadari@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, dbrownell@users.sourceforge.net
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20070326205706.a750bb35.akpm@linux-foundation.org>
References: <20070326205706.a750bb35.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 27 Mar 2007 09:54:07 -0800
Message-Id: <1175018047.16728.24.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-26 at 20:57 -0800, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm1/
> 
> 

  CC [M]  drivers/parport/parport_pc.o
In file included from drivers/parport/parport_pc.c:66:
include/asm/parport.h:18: error: conflicting types for
‘parport_pc_probe_port’
include/linux/parport_pc.h:234: error: previous declaration of
‘parport_pc_probe_port’ was here
drivers/parport/parport_pc.c:2379: error: conflicting types for
‘parport_pc_probe_port’
drivers/parport/parport_pc.c:2152: error: previous definition of
‘parport_pc_probe_port’ was here
drivers/parport/parport_pc.c: In function ‘sio_ite_8872_probe’:
drivers/parport/parport_pc.c:2509: warning: passing argument 5 of
‘parport_pc_probe_port’ from incompatible pointer type
drivers/parport/parport_pc.c: In function ‘sio_via_probe’:
drivers/parport/parport_pc.c:2692: warning: passing argument 5 of
‘parport_pc_probe_port’ from incompatible pointer type
drivers/parport/parport_pc.c: In function ‘parport_pc_pci_probe’:
drivers/parport/parport_pc.c:2990: warning: passing argument 5 of
‘parport_pc_probe_port’ from incompatible pointer type
drivers/parport/parport_pc.c: In function ‘parport_pc_pnp_probe’:
drivers/parport/parport_pc.c:3098: warning: passing argument 5 of
‘parport_pc_probe_port’ from incompatible pointer type
make[2]: *** [drivers/parport/parport_pc.o] Error 1
make[1]: *** [drivers/parport] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [drivers] Error 2
make: *** Waiting for unfinished jobs....


Patch that is causing the problem in -mm:
parport-dev-driver-model-support.patch


Here is the fix.

Thanks,
Badari

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
---
 include/asm-powerpc/parport.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.21-rc5/include/asm-powerpc/parport.h
===================================================================
--- linux-2.6.21-rc5.orig/include/asm-powerpc/parport.h	2007-03-27 09:47:13.000000000 -0700
+++ linux-2.6.21-rc5/include/asm-powerpc/parport.h	2007-03-27 09:47:54.000000000 -0700
@@ -15,7 +15,7 @@
 extern struct parport *parport_pc_probe_port (unsigned long int base,
                                               unsigned long int base_hi,
                                               int irq, int dma,
-                                              struct pci_dev *dev);
+                                              struct device *dev);
 
 static int __devinit parport_pc_find_nonpci_ports (int autoirq, int autodma)
 {


