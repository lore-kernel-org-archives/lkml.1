Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804Ab0BLVDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 16:03:34 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:44271 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757609Ab0BLVD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 16:03:29 -0500
Date: Fri, 12 Feb 2010 13:02:35 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-media@vger.kernel.org, Mocean Laboratories <info@mocean-labs.com>
Subject: [PATCH -next] radio_timberdale: depends on I2c
Message-Id: <20100212130235.d5874398.randy.dunlap@oracle.com>
In-Reply-To: <20100212181304.a7bd9a63.sfr@canb.auug.org.au>
References: <20100212181304.a7bd9a63.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4B75C214.004D:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

RADIO_TIMBERDALE selects RADIO_SAA7706H, but RADIO_SAA7706H
depends on I2C, so make RADIO_TIMBERDALE depend on I2C also;
otherwise there are build errors:

drivers/media/radio/saa7706h.c:139: error: implicit declaration of function 'i2c_master_send'
drivers/media/radio/saa7706h.c:148: error: implicit declaration of function 'i2c_transfer'
drivers/media/radio/saa7706h.c:372: error: implicit declaration of function 'i2c_check_functionality'
drivers/media/radio/saa7706h.c:375: error: implicit declaration of function 'i2c_adapter_id'
drivers/media/radio/saa7706h.c:438: error: implicit declaration of function 'i2c_add_driver'
drivers/media/radio/saa7706h.c:443: error: implicit declaration of function 'i2c_del_driver'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mocean Laboratories <info@mocean-labs.com>
---
 drivers/media/radio/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20100212.orig/drivers/media/radio/Kconfig
+++ linux-next-20100212/drivers/media/radio/Kconfig
@@ -444,6 +444,7 @@ config RADIO_TEF6862
 config RADIO_TIMBERDALE
 	tristate "Enable the Timberdale radio driver"
 	depends on MFD_TIMBERDALE && VIDEO_V4L2
+	depends on I2C	# for RADIO_SAA7706H
 	select RADIO_TEF6862
 	select RADIO_SAA7706H
 	---help---
