Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933180Ab0BYRzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 12:55:42 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:43729 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933098Ab0BYRzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 12:55:40 -0500
Message-ID: <4B86B97D.6030208@oracle.com>
Date: Thu, 25 Feb 2010 09:55:09 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH -next] fs: fix compat_ioctl when CONFIG_BLOCK=n
References: <20100225183523.80361261.sfr@canb.auug.org.au>
In-Reply-To: <20100225183523.80361261.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4B86B990.0234:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

fs/compat_ioctl.c should omit pktcdvd.h and its ioctl when CONFIG_BLOCK
is not enabled.  This fixes these build errors:

In file included from fs/compat_ioctl.c:105:
include/linux/pktcdvd.h:166: error: field 'read_queue' has incomplete type
include/linux/pktcdvd.h:167: error: field 'write_queue' has incomplete type
include/linux/pktcdvd.h:207: error: field 'orig_bios' has incomplete type
make[2]: *** [fs/compat_ioctl.o] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/compat_ioctl.c |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-next-20100225.orig/fs/compat_ioctl.c
+++ linux-next-20100225/fs/compat_ioctl.c
@@ -102,7 +102,9 @@
 #include <linux/nbd.h>
 #include <linux/random.h>
 #include <linux/filter.h>
+#ifdef CONFIG_BLOCK
 #include <linux/pktcdvd.h>
+#endif
 
 #include <linux/hiddev.h>
 
@@ -1126,8 +1128,10 @@ COMPATIBLE_IOCTL(PPGETMODE)
 COMPATIBLE_IOCTL(PPGETPHASE)
 COMPATIBLE_IOCTL(PPGETFLAGS)
 COMPATIBLE_IOCTL(PPSETFLAGS)
+#ifdef CONFIG_BLOCK
 /* pktcdvd */
 COMPATIBLE_IOCTL(PACKET_CTRL_CMD)
+#endif
 /* Big A */
 /* sparc only */
 /* Big Q for sound/OSS */
