Return-Path: <linux-kernel-owner+w=401wt.eu-S1754213AbZHJXHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbZHJXHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 19:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754071AbZHJXHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 19:07:18 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:64714 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbZHJXHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 19:07:16 -0400
Date: Mon, 10 Aug 2009 16:04:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-media@vger.kernel.org,
       akpm <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Uri Shkolnik <uris@siano-ms.com>
Subject: [PATCH -next] dvb: siano uses/depends on INPUT
Message-Id: <20090810160455.4f93ad60.randy.dunlap@oracle.com>
In-Reply-To: <20090810203508.f3258129.sfr@canb.auug.org.au>
References: <20090810203508.f3258129.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt004.oracle.com [141.146.116.13]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010209.4A80A7C9.00C5:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

siano uses input_*() functions so it should depend on INPUT
to prevent build errors:

ERROR: "input_event" [drivers/media/dvb/siano/sms1xxx.ko] undefined!
ERROR: "input_register_device" [drivers/media/dvb/siano/sms1xxx.ko] undefined!
ERROR: "input_free_device" [drivers/media/dvb/siano/sms1xxx.ko] undefined!
ERROR: "input_unregister_device" [drivers/media/dvb/siano/sms1xxx.ko] undefined!
ERROR: "input_allocate_device" [drivers/media/dvb/siano/sms1xxx.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Michael Krufky <mkrufky@linuxtv.org>
Cc: Uri Shkolnik <uris@siano-ms.com>
---
 drivers/media/dvb/siano/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20090810.orig/drivers/media/dvb/siano/Kconfig
+++ linux-next-20090810/drivers/media/dvb/siano/Kconfig
@@ -4,7 +4,7 @@
 
 config DVB_SIANO_SMS1XXX
 	tristate "Siano SMS1XXX USB dongle support"
-	depends on DVB_CORE && USB
+	depends on DVB_CORE && USB && INPUT
 	---help---
 	  Choose Y here if you have a USB dongle with a SMS1XXX chipset.
 



---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
