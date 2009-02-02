Return-Path: <linux-kernel-owner+w=401wt.eu-S1754685AbZBBTWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbZBBTWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 14:22:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbZBBTVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 14:21:54 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:52970 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbZBBTVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 14:21:54 -0500
Date: Mon, 2 Feb 2009 11:20:55 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Dave Kleikamp <shaggy@austin.ibm.com>
Subject: [PATCH] jfs: needs crc32_le
Message-Id: <20090202112055.5ad37047.randy.dunlap@oracle.com>
In-Reply-To: <20090202201637.28896d2f.sfr@canb.auug.org.au>
References: <20090202201637.28896d2f.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020B.4987479A.0201:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

JFS needs crc32_le(), so select its library config symbol:

fs/built-in.o: In function `jfs_statfs':
super.c:(.text+0x7c8c0): undefined reference to `crc32_le'
super.c:(.text+0x7c8d5): undefined reference to `crc32_le'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Dave Kleikamp <shaggy@austin.ibm.com>
---
 fs/jfs/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20090202.orig/fs/jfs/Kconfig
+++ linux-next-20090202/fs/jfs/Kconfig
@@ -1,6 +1,7 @@
 config JFS_FS
 	tristate "JFS filesystem support"
 	select NLS
+	select CRC32
 	help
 	  This is a port of IBM's Journaled Filesystem .  More information is
 	  available in the file <file:Documentation/filesystems/jfs.txt>.
