Return-Path: <linux-kernel-owner+w=401wt.eu-S1755881AbYDIOdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbYDIOdD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 10:33:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755392AbYDIOcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 10:32:54 -0400
Received: from pima.mpagano.com ([67.228.218.97]:46770 "EHLO pima.mpagano.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752119AbYDIOcx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 10:32:53 -0400
X-Greylist: delayed 547 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Apr 2008 10:32:53 EDT
From: Mike Pagano <mpagano@gentoo.org>
To: jens.axboe@oracle.com
Subject: [PATCH] cciss: error: implicit declaration of function 'sg_init_table'
Date: Wed, 9 Apr 2008 10:23:39 -0400
User-Agent: KMail/1.9.9
Cc: dsd@gentoo.org, iss_storagedev@hp.com,
       linux kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804091023.40068.mpagano@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the missing include directive <linux/scatterlist.h> to the cciss.c source file.  
This was discovered by our release team when building the kernel for the Alpha architecture.

Errors were found as references to functions 'sg_init_table' and 'sg_page' do not exist without the include for Alpha.

Signed off by: Mike Pagano <mpagano@gentoo.org>
---
 drivers/block/cciss.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/block/cciss.c 2008-04-09 10:13:45.000000000 -0400
+++ b/drivers/block/cciss.c 2008-04-09 10:14:11.000000000 -0400
@@ -50,6 +50,7 @@
 #include <scsi/sg.h>
 #include <scsi/scsi_ioctl.h>
 #include <linux/cdrom.h>
+#include <linux/scatterlist.h>

 #define CCISS_DRIVER_VERSION(maj,min,submin) ((maj<<16)|(min<<8)|(submin))
 #define DRIVER_NAME "HP CISS Driver (v 3.6.14)"
