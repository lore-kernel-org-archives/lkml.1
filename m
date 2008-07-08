Return-Path: <linux-kernel-owner+w=401wt.eu-S1753629AbYGHV1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbYGHV1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 17:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbYGHV1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 17:27:24 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:62539 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbYGHV1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 17:27:23 -0400
Date: Tue, 8 Jul 2008 14:23:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-next@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Cc: jens.axboe@oracle.com, jejb <James.Bottomley@HansenPartnership.com>,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] compat_ioctl: handle BLOCK=n, SCSI=n
Message-Id: <20080708142354.76106541.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix fs/compat_ioctl.c to handle CONFIG_BLOCK=n, CONFIG_SCSI=n
to avoid build errors:

In file included from linux-next-20080708/include/scsi/scsi.h:12,
                 from linux-next-20080708/fs/compat_ioctl.c:71:
linux-next-20080708/include/scsi/scsi_cmnd.h:27:25: warning: "BLK_MAX_CDB" is not defined
linux-next-20080708/include/scsi/scsi_cmnd.h:28:3: error: #error MAX_COMMAND_SIZE can not be bigger than BLK_MAX_CDB
In file included from linux-next-20080708/include/scsi/scsi.h:12,
                 from linux-next-20080708/fs/compat_ioctl.c:71:
linux-next-20080708/include/scsi/scsi_cmnd.h: In function 'scsi_bidi_cmnd':
linux-next-20080708/include/scsi/scsi_cmnd.h:182: error: implicit declaration of function 'blk_bidi_rq'
linux-next-20080708/include/scsi/scsi_cmnd.h:183: error: dereferencing pointer to incomplete type
linux-next-20080708/include/scsi/scsi_cmnd.h: In function 'scsi_in':
linux-next-20080708/include/scsi/scsi_cmnd.h:189: error: dereferencing pointer to incomplete type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/compat_ioctl.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- linux-next-20080708.orig/fs/compat_ioctl.c
+++ linux-next-20080708/fs/compat_ioctl.c
@@ -68,9 +68,11 @@
 #include <linux/capi.h>
 #include <linux/gigaset_dev.h>
 
+#ifdef CONFIG_BLOCK
 #include <scsi/scsi.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/sg.h>
+#endif
 
 #include <asm/uaccess.h>
 #include <linux/ethtool.h>
@@ -1965,6 +1967,7 @@ COMPATIBLE_IOCTL(GIO_UNISCRNMAP)
 COMPATIBLE_IOCTL(PIO_UNISCRNMAP)
 COMPATIBLE_IOCTL(PIO_FONTRESET)
 COMPATIBLE_IOCTL(PIO_UNIMAPCLR)
+#ifdef CONFIG_BLOCK
 /* Big S */
 COMPATIBLE_IOCTL(SCSI_IOCTL_GET_IDLUN)
 COMPATIBLE_IOCTL(SCSI_IOCTL_DOORLOCK)
@@ -1974,6 +1977,7 @@ COMPATIBLE_IOCTL(SCSI_IOCTL_GET_BUS_NUMB
 COMPATIBLE_IOCTL(SCSI_IOCTL_SEND_COMMAND)
 COMPATIBLE_IOCTL(SCSI_IOCTL_PROBE_HOST)
 COMPATIBLE_IOCTL(SCSI_IOCTL_GET_PCI)
+#endif
 /* Big T */
 COMPATIBLE_IOCTL(TUNSETNOCSUM)
 COMPATIBLE_IOCTL(TUNSETDEBUG)
@@ -2044,6 +2048,7 @@ COMPATIBLE_IOCTL(SIOCGIFVLAN)
 COMPATIBLE_IOCTL(SIOCSIFVLAN)
 COMPATIBLE_IOCTL(SIOCBRADDBR)
 COMPATIBLE_IOCTL(SIOCBRDELBR)
+#ifdef CONFIG_BLOCK
 /* SG stuff */
 COMPATIBLE_IOCTL(SG_SET_TIMEOUT)
 COMPATIBLE_IOCTL(SG_GET_TIMEOUT)
@@ -2068,6 +2073,7 @@ COMPATIBLE_IOCTL(SG_SCSI_RESET)
 COMPATIBLE_IOCTL(SG_GET_REQUEST_TABLE)
 COMPATIBLE_IOCTL(SG_SET_KEEP_ORPHAN)
 COMPATIBLE_IOCTL(SG_GET_KEEP_ORPHAN)
+#endif
 /* PPP stuff */
 COMPATIBLE_IOCTL(PPPIOCGFLAGS)
 COMPATIBLE_IOCTL(PPPIOCSFLAGS)


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
