Return-Path: <linux-kernel-owner+w=401wt.eu-S1751729AbXKFSgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729AbXKFSgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 13:36:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754942AbXKFSfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 13:35:54 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:37631 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbXKFSfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 13:35:53 -0500
Subject: Re: mm snapshot broken-out-2007-11-06-02-32.tar.gz uploaded
From: Badari Pulavarty <pbadari@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Greg K-H <greg@kroah.com>
Cc: mm-commits@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org>
References: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 06 Nov 2007 10:36:58 -0800
Message-Id: <1194374218.26782.6.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-06 at 02:33 -0800, akpm@linux-foundation.org wrote:
> The mm snapshot broken-out-2007-11-06-02-32.tar.gz has been uploaded to
> 
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-11-06-02-32.tar.gz
> 

> gregkh-driver-kset-convert-sys-devices-to-use-kset_create.patch

Above patch renamed devices_subsys to devices_kset to catch all users of
the variable. Need fixes to vio.


# make -j8 zImage
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
<stdin>:1389:2: warning: #warning syscall revokeat not implemented
<stdin>:1393:2: warning: #warning syscall frevoke not implemented
  CHK     include/linux/compile.h
  GEN     .version
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
arch/powerpc/kernel/built-in.o(.toc+0x1548): undefined reference to
`devices_subsys'
make: *** [.tmp_vmlinux1] Error 1


Here is the patch, Is this correct usage ?

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
 



