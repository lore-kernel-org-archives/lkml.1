Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028AbZALSyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbZALSyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 13:54:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbZALSxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 13:53:55 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:36467 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbZALSxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 13:53:54 -0500
Message-ID: <496B9190.5030503@oracle.com>
Date: Mon, 12 Jan 2009 10:53:04 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       scsi <linux-scsi@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>, mkp@mkp.net
Subject: [PATCH -next] scsi_debug: needs CRC_T10DIF
References: <20090112154539.4857f533.sfr@canb.auug.org.au>
In-Reply-To: <20090112154539.4857f533.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020B.496B9194.0062:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix scsi_debug build error:

drivers/built-in.o: In function `resp_read':
scsi_debug.c:(.text+0x21379a): undefined reference to `crc_t10dif'
drivers/built-in.o: In function `resp_write':
scsi_debug.c:(.text+0x213fca): undefined reference to `crc_t10dif'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20090112.orig/drivers/scsi/Kconfig
+++ linux-next-20090112/drivers/scsi/Kconfig
@@ -1535,6 +1535,7 @@ config SCSI_NSP32
 config SCSI_DEBUG
 	tristate "SCSI debugging host simulator"
 	depends on SCSI
+	select CRC_T10DIF
 	help
 	  This is a host adapter simulator that can simulate multiple hosts
 	  each with multiple dummy SCSI devices (disks). It defaults to one

