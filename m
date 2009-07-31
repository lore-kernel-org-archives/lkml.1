Return-Path: <linux-kernel-owner+w=401wt.eu-S1753129AbZGaVqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbZGaVqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 17:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbZGaVqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 17:46:21 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:38233 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbZGaVqV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 17:46:21 -0400
Date: Fri, 31 Jul 2009 14:45:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: akpm@linux-foundation.org,
       David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH -mmotm] input/winbond-cir: select BITREVERSE
Message-Id: <20090731144550.c0861733.randy.dunlap@oracle.com>
In-Reply-To: <200907301204.n6UC4Saf019612@imap1.linux-foundation.org>
References: <200907301204.n6UC4Saf019612@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Source-IP: abhmt008.oracle.com [141.146.116.17]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4A736619.0021:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

winbond-cir driver uses bitreverse functions so it needs to
select BITREVERSE to fix these build errors:

drivers/built-in.o: In function `wbcir_shutdown':
winbond-cir.c:(.text+0x104fc7): undefined reference to `byte_rev_table'
winbond-cir.c:(.text+0x104fd8): undefined reference to `byte_rev_table'
winbond-cir.c:(.text+0x104ff4): undefined reference to `byte_rev_table'
drivers/built-in.o: In function `wbcir_irq_handler':
winbond-cir.c:(.text+0x105f47): undefined reference to `byte_rev_table'
winbond-cir.c:(.text+0x105f5f): undefined reference to `byte_rev_table'
drivers/built-in.o:winbond-cir.c:(.text+0x105f77): more undefined references to `byte_rev_table' follow

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Härdeman <david@hardeman.nu>
---
 drivers/input/misc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- mmotm-2009-0730-0501.orig/drivers/input/misc/Kconfig
+++ mmotm-2009-0730-0501/drivers/input/misc/Kconfig
@@ -226,6 +226,7 @@ config INPUT_WINBOND_CIR
 	tristate "Winbond IR remote control"
 	depends on X86 && ACPI
 	select LEDS_CLASS
+	select BITREVERSE
 	help
 	  Say Y here if you want to use the IR remote functionality found
 	  in some Winbond SuperI/O chips. Currently only the WPCD376I



---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
