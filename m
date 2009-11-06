Return-Path: <linux-kernel-owner+w=401wt.eu-S932651AbZKFWdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651AbZKFWdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932717AbZKFWdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:33:16 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:65305 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932704AbZKFWdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:33:13 -0500
Message-ID: <4AF4B259.8030506@oracle.com>
Date: Fri, 06 Nov 2009 15:33:45 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH -next] kmemleak: fix kconfig for crc32 build error
References: <20091106181330.80bca052.sfr@canb.auug.org.au>
In-Reply-To: <20091106181330.80bca052.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4AF4A410.00D4:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

kmemleak uses crc32 functions so it needs to select CRC32.
Fixes build error:

kmemleak.c:(.text+0x7ce62): undefined reference to `crc32_le'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
---
 lib/Kconfig.debug |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20091106.orig/lib/Kconfig.debug
+++ linux-next-20091106/lib/Kconfig.debug
@@ -372,6 +372,7 @@ config DEBUG_KMEMLEAK
 	select DEBUG_FS if SYSFS
 	select STACKTRACE if STACKTRACE_SUPPORT
 	select KALLSYMS
+	select CRC32
 	help
 	  Say Y here if you want to enable the memory leak
 	  detector. The memory allocation/freeing is traced in a way
