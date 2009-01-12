Return-Path: <linux-kernel-owner+w=401wt.eu-S1755797AbZALSve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797AbZALSve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 13:51:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbZALSvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 13:51:23 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:19453 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbZALSvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 13:51:22 -0500
Message-ID: <496B9112.8070908@oracle.com>
Date: Mon, 12 Jan 2009 10:50:58 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       scsi <linux-scsi@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -next] libfc: needs CRC32
References: <20090112154539.4857f533.sfr@canb.auug.org.au>
In-Reply-To: <20090112154539.4857f533.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.496B9117.00DF:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

libfc uses crc32 functions, so cause it to be built
via select:

drivers/built-in.o: In function `fc_frame_crc_check':
(.text+0x75dae): undefined reference to `crc32_le'
drivers/built-in.o: In function `fc_fcp_recv':
fc_fcp.c:(.text+0x7b919): undefined reference to `crc32_le'
fc_fcp.c:(.text+0x7b9d5): undefined reference to `crc32_le'
fc_fcp.c:(.text+0x7ba54): undefined reference to `crc32_le'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20090112.orig/drivers/scsi/Kconfig
+++ linux-next-20090112/drivers/scsi/Kconfig
@@ -608,6 +608,7 @@ config SCSI_FLASHPOINT
 config LIBFC
 	tristate "LibFC module"
 	select SCSI_FC_ATTRS
+	select CRC32
 	---help---
 	  Fibre Channel library module
 

-- 
~Randy
