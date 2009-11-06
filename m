Return-Path: <linux-kernel-owner+w=401wt.eu-S1759293AbZKFSJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759293AbZKFSJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 13:09:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758858AbZKFSJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 13:09:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:62589 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbZKFSJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 13:09:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, Christoph Hellwig <hch@lst.de>,
       netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/7] compat: add struct compat_ifreq etc to compat.h
Date: Fri,  6 Nov 2009 19:09:03 +0100
Message-Id: <1257530949-9695-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1257530949-9695-1-git-send-email-arnd@arndb.de>
References: <1257530949-9695-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+F72FWZIs8rmiBuC8TX1NHWCFUSl2Ic3/nAvC
 i7VmrXmlOKExliiz73OuwFdHNMo9YNpc23cXra7589nJVu/Ydg
 KZFN3AvQUrRXvn3kV7ilg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to move socket ioctl conversion code into multiple
places in the socket code, we need a common defintion of
the data structures it uses.

Also change the name from ifreq32 to compat_ifreq to
follow the naming convention for compat.h

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/compat.h |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index af931ee..8311d2e 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -10,6 +10,8 @@
 #include <linux/stat.h>
 #include <linux/param.h>	/* for HZ */
 #include <linux/sem.h>
+#include <linux/socket.h>
+#include <linux/if.h>
 
 #include <asm/compat.h>
 #include <asm/siginfo.h>
@@ -154,6 +156,43 @@ typedef struct compat_sigevent {
 	} _sigev_un;
 } compat_sigevent_t;
 
+struct compat_ifmap {
+	compat_ulong_t mem_start;
+	compat_ulong_t mem_end;
+	unsigned short base_addr;
+	unsigned char irq;
+	unsigned char dma;
+	unsigned char port;
+};
+
+struct compat_ifreq {
+#define IFHWADDRLEN     6
+#define IFNAMSIZ        16
+        union {
+                char    ifrn_name[IFNAMSIZ];            /* if name, e.g. "en0" */
+        } ifr_ifrn;
+        union {
+                struct  sockaddr ifru_addr;
+                struct  sockaddr ifru_dstaddr;
+                struct  sockaddr ifru_broadaddr;
+                struct  sockaddr ifru_netmask;
+                struct  sockaddr ifru_hwaddr;
+                short   ifru_flags;
+                compat_int_t     ifru_ivalue;
+                compat_int_t     ifru_mtu;
+                struct  compat_ifmap ifru_map;
+                char    ifru_slave[IFNAMSIZ];   /* Just fits the size */
+		char	ifru_newname[IFNAMSIZ];
+                compat_caddr_t ifru_data;
+	    /* XXXX? ifru_settings should be here */
+        } ifr_ifru;
+};
+
+struct compat_ifconf {
+        compat_int_t	ifc_len;                        /* size of buffer       */
+        compat_caddr_t  ifcbuf;
+};
+
 struct compat_robust_list {
 	compat_uptr_t			next;
 };
-- 
1.6.3.3

