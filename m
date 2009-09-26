Return-Path: <linux-kernel-owner+w=401wt.eu-S1752878AbZIZPhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbZIZPhW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 11:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbZIZPhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 11:37:22 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:33871 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbZIZPhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 11:37:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=F/dQZE7BUWRlvm/B9a92I4n/zD3eRSALdPwO0Pq6VNZKlyEVmHHN1huyo0RuUovzuZ
         r4N2v4/Pm1c+UAOTDoeKZD6XEqWuENQ+0cgzg43dxpxZksXHBubNUUjTO3ceR+rSJdQL
         YqQZapoD+7RgZVNRK1EVil7NdC91K611CaRjE=
Date: Sat, 26 Sep 2009 19:37:22 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] headers: kref.h redux
Message-ID: <20090926153722.GA4298@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* remove asm/atomic.h inclusion from kref.h -- not needed, linux/types.h
  is enough for atomic_t
* remove linux/kref.h inclusion from files which do not need it.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/net/irda/kingsun-sir.c           |    1 -
 drivers/net/irda/ks959-sir.c             |    1 -
 drivers/net/irda/ksdazzle-sir.c          |    1 -
 drivers/net/irda/mcs7780.c               |    1 -
 drivers/scsi/pmcraid.h                   |    1 -
 drivers/usb/misc/sisusbvga/sisusb_init.c |    1 -
 include/linux/ipc.h                      |    2 --
 include/linux/kref.h                     |    1 -
 include/linux/nfs_fs.h                   |    1 -
 9 files changed, 10 deletions(-)

--- a/drivers/net/irda/kingsun-sir.c
+++ b/drivers/net/irda/kingsun-sir.c
@@ -66,7 +66,6 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/kref.h>
 #include <linux/usb.h>
 #include <linux/device.h>
 #include <linux/crc32.h>
--- a/drivers/net/irda/ks959-sir.c
+++ b/drivers/net/irda/ks959-sir.c
@@ -118,7 +118,6 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/kref.h>
 #include <linux/usb.h>
 #include <linux/device.h>
 #include <linux/crc32.h>
--- a/drivers/net/irda/ksdazzle-sir.c
+++ b/drivers/net/irda/ksdazzle-sir.c
@@ -82,7 +82,6 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/kref.h>
 #include <linux/usb.h>
 #include <linux/device.h>
 #include <linux/crc32.h>
--- a/drivers/net/irda/mcs7780.c
+++ b/drivers/net/irda/mcs7780.c
@@ -50,7 +50,6 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/kref.h>
 #include <linux/usb.h>
 #include <linux/device.h>
 #include <linux/crc32.h>
--- a/drivers/scsi/pmcraid.h
+++ b/drivers/scsi/pmcraid.h
@@ -26,7 +26,6 @@
 #include <linux/completion.h>
 #include <linux/list.h>
 #include <scsi/scsi.h>
-#include <linux/kref.h>
 #include <scsi/scsi_cmnd.h>
 #include <linux/cdev.h>
 #include <net/netlink.h>
--- a/drivers/usb/misc/sisusbvga/sisusb_init.c
+++ b/drivers/usb/misc/sisusbvga/sisusb_init.c
@@ -43,7 +43,6 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/kref.h>
 
 #include "sisusb.h"
 
--- a/include/linux/ipc.h
+++ b/include/linux/ipc.h
@@ -78,8 +78,6 @@ struct ipc_kludge {
 #define IPCCALL(version,op)	((version)<<16 | (op))
 
 #ifdef __KERNEL__
-
-#include <linux/kref.h>
 #include <linux/spinlock.h>
 
 #define IPCMNI 32768  /* <= MAX_INT limit for ipc arrays (including sysctl changes) */
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -16,7 +16,6 @@
 #define _KREF_H_
 
 #include <linux/types.h>
-#include <asm/atomic.h>
 
 struct kref {
 	atomic_t refcount;
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -40,7 +40,6 @@
 #ifdef __KERNEL__
 
 #include <linux/in.h>
-#include <linux/kref.h>
 #include <linux/mm.h>
 #include <linux/pagemap.h>
 #include <linux/rbtree.h>
