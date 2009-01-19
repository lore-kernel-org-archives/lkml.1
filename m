Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbZASSvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbZASSvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 13:51:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbZASSvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 13:51:45 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:32059 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbZASSvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 13:51:45 -0500
Message-ID: <4974CBB3.4020102@oracle.com>
Date: Mon, 19 Jan 2009 10:51:31 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
CC: linux-kernel@vger.kernel.org, Alexey Korolev <akorolev@infradead.org>,
       linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: build issue #583 for v2.6.29-rc2-13-gf3b8436 : undefined reference
 to `lpddr_cmdset'
References: <200901191938.08911.toralf.foerster@gmx.de>
In-Reply-To: <200901191938.08911.toralf.foerster@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4974CBB6.00EE:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Toralf Förster wrote:
> Hello,
> 
> the build (.config attached) failed, make ends with :
> ...
>   CC      arch/x86/lib/usercopy_32.o
>   AR      arch/x86/lib/lib.a
>   LD      vmlinux.o
>   MODPOST vmlinux.o
> WARNING: modpost: Found 1 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>   KSYM    .tmp_kallsyms0.S
>   AS      .tmp_kallsyms0.o
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `lpddr_probe':
> (.text+0x17a1ae): undefined reference to `lpddr_cmdset'
> make: *** [.tmp_vmlinux1] Error 1


Repeating an email reply from last week:

This patch has been posted, just needs to be merged (hint):
---


Signed-off-by: Alexey Korolev <akorolev@infradead.org>
---
diff --git a/drivers/mtd/lpddr/Kconfig b/drivers/mtd/lpddr/Kconfig
index acd4ea9..5a401d8 100644
--- a/drivers/mtd/lpddr/Kconfig
+++ b/drivers/mtd/lpddr/Kconfig
@@ -12,6 +12,7 @@ config MTD_LPDDR
 	  DDR memories, intended for battery-operated systems.
 
 config MTD_QINFO_PROBE
+	depends on MTD_LPDDR
 	tristate "Detect flash chips by QINFO probe"
 	help
 	    Device Information for LPDDR chips is offered through the Overlay

-- 
~Randy
