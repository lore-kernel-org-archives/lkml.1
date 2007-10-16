Return-Path: <linux-kernel-owner+w=401wt.eu-S932481AbXJPFuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481AbXJPFuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 01:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760930AbXJPFtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 01:49:55 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:57218 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760838AbXJPFtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 01:49:55 -0400
Message-ID: <471450DD.1060907@linux.vnet.ibm.com>
Date: Tue, 16 Oct 2007 11:19:17 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>
Subject: 2.6.23-git8 missing include file
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The build fails with following error

  CC      drivers/usb/storage/scsiglue.o
  CC      drivers/usb/storage/protocol.o
  CC      drivers/usb/storage/transport.o
In file included from drivers/usb/storage/transport.c:53:
include/scsi/scsi_eh.h:79: error: field 'sense_sgl' has incomplete type
make[3]: *** [drivers/usb/storage/transport.o] Error 1
make[2]: *** [drivers/usb/storage] Error 2
make[1]: *** [drivers/usb] Error 2
make: *** [drivers] Error 2

This patch fixes the build failure

--- linux-2.6.23/include/scsi/scsi_cmnd.h       2007-10-16 09:58:30.000000000 +0530
+++ linux-2.6.23/include/scsi/~scsi_cmnd.h      2007-10-16 10:20:32.000000000 +0530
@@ -5,6 +5,7 @@
 #include <linux/list.h>
 #include <linux/types.h>
 #include <linux/timer.h>
+#include <linux/scatterlist.h>
 
 struct request;
 struct scatterlist;

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
