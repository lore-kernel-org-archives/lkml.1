Return-Path: <linux-kernel-owner+w=401wt.eu-S1754189AbZHJXGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbZHJXGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 19:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754071AbZHJXGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 19:06:47 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:64059 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021AbZHJXGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 19:06:46 -0400
Date: Mon, 10 Aug 2009 16:04:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Timur Tabi <timur@freescale.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] soc: fix I2C build errors
Message-Id: <20090810160439.72e417de.randy.dunlap@oracle.com>
In-Reply-To: <20090810203508.f3258129.sfr@canb.auug.org.au>
References: <20090810203508.f3258129.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt007.oracle.com [141.146.116.16]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010203.4A80A7B9.0055:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix soc build errors when I2C is built as a loadable module:

(.text+0x5d26b): undefined reference to `i2c_master_send'
soc-cache.c:(.text+0x5d32d): undefined reference to `i2c_transfer'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Timur Tabi <timur@freescale.com>
---
 sound/soc/soc-cache.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20090810.orig/sound/soc/soc-cache.c
+++ linux-next-20090810/sound/soc/soc-cache.c
@@ -108,7 +108,7 @@ static unsigned int snd_soc_8_16_read(st
 		return cache[reg];
 }
 
-#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
+#if defined(CONFIG_I2C) || (defined(CONFIG_I2C_MODULE) && defined(MODULE))
 static unsigned int snd_soc_8_16_read_i2c(struct snd_soc_codec *codec,
 					  unsigned int r)
 {
@@ -200,7 +200,7 @@ int snd_soc_codec_set_cache_io(struct sn
 		break;
 
 	case SND_SOC_I2C:
-#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
+#if defined(CONFIG_I2C) || (defined(CONFIG_I2C_MODULE) && defined(MODULE))
 		codec->hw_write = (hw_write_t)i2c_master_send;
 #endif
 		if (io_types[i].i2c_read)



---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
