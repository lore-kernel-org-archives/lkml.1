Return-Path: <linux-kernel-owner+w=401wt.eu-S1755143AbZICLwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbZICLwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 07:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755114AbZICLwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 07:52:14 -0400
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:42085 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087AbZICLwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 07:52:13 -0400
Date: Thu, 3 Sep 2009 17:22:13 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix missing include file in RTL8192U staging driver
Message-ID: <20090903115213.GA4315@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

	2.6.31-rc8 build fails with

drivers/staging/rtl8192su/r8192U_core.c:5086: error: implicit declaration of function 'vmalloc'
drivers/staging/rtl8192su/r8192U_core.c:5086: warning: cast to pointer from integer of different size
drivers/staging/rtl8192su/r8192U_core.c: In function 'rtl8192_usb_disconnect':
drivers/staging/rtl8192su/r8192U_core.c:12308: error: implicit declaration of function 'vfree'

Including the vmalloc.h file, fixes the build failure. I have tested the
patch for build failure only.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--
 drivers/staging/rtl8192su/r8192U_core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rtl8192su/r8192U_core.c b/drivers/staging/rtl8192su/r8192U_core.c
index 70f81a8..0734fec 100644
--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -75,6 +75,7 @@ double __extendsfdf2(float a) {return a;}
 #include "r8192U_dm.h"
 //#include "r8192xU_phyreg.h"
 #include <linux/usb.h>
+#include <linux/vmalloc.h>
 // FIXME: check if 2.6.7 is ok
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,7))
 #define usb_kill_urb usb_unlink_urb
@@ -102,6 +103,7 @@ double __extendsfdf2(float a) {return a;}
 #include "r8192U_dm.h"
 //#include "r8192xU_phyreg.h"
 #include <linux/usb.h>
+#include <linux/vmalloc.h>
 // FIXME: check if 2.6.7 is ok
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,7))
 #define usb_kill_urb usb_unlink_urb
			
			Kamalesh
