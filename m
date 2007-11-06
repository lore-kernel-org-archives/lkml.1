Return-Path: <linux-kernel-owner+w=401wt.eu-S1757045AbXKFS7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045AbXKFS7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 13:59:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbXKFS7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 13:59:23 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:50327 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbXKFS7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 13:59:22 -0500
Subject: Re: mm snapshot broken-out-2007-11-06-02-32 - powerpc link failure
From: Badari Pulavarty <pbadari@gmail.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <4730AF9E.7020908@linux.vnet.ibm.com>
References: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org>
	 <4730AF9E.7020908@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 06 Nov 2007 11:00:38 -0800
Message-Id: <1194375638.26782.8.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-06 at 23:47 +0530, Kamalesh Babulal wrote:
> Hi Andrew,
> 
> The kernel linking fails on the powerpc, with following error message
> 
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> arch/powerpc/kernel/built-in.o(.toc+0x1550): undefined reference to `devices_subsys'
> make: *** [.tmp_vmlinux1] Error 1

I sent a fix for this 30 minutes ago ..

Here it is anyway.

Thanks,
Badari

---
 arch/powerpc/kernel/vio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.24-rc1/arch/powerpc/kernel/vio.c
===================================================================
--- linux-2.6.24-rc1.orig/arch/powerpc/kernel/vio.c	2007-10-23 20:50:57.000000000 -0700
+++ linux-2.6.24-rc1/arch/powerpc/kernel/vio.c	2007-11-06 10:31:56.000000000 -0800
@@ -37,7 +37,7 @@
 #include <asm/iseries/hv_call_xm.h>
 #include <asm/iseries/iommu.h>
 
-extern struct kset devices_subsys; /* needed for vio_find_name() */
+extern struct kset *devices_kset;  /* needed for vio_find_name() */
 
 static struct bus_type vio_bus_type;
 
@@ -369,7 +369,7 @@ static struct vio_dev *vio_find_name(con
 {
 	struct kobject *found;
 
-	found = kset_find_obj(&devices_subsys, kobj_name);
+	found = kset_find_obj(devices_kset, kobj_name);
 	if (!found)
 		return NULL;
 



