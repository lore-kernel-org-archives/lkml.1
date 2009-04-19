Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003AbZDSBCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbZDSBCT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 21:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbZDSBCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 21:02:10 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:49991 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbZDSBCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 21:02:09 -0400
Message-ID: <49EA77DE.7040700@oracle.com>
Date: Sat, 18 Apr 2009 18:01:18 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andres Salomon <dilinger@queued.net>
CC: akpm@linux-foundation.org, david-b@pacbell.net, jordan@cosmicpenguin.net,
       katzj@redhat.com, tiwai@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] cs553x: fix build dependency problems
References: <200904062355.n36NtLTf018342@imap1.linux-foundation.org>	<49DFA576.6040005@oracle.com> <20090412215203.45e2a876@ephemeral> <49E2BEE2.8070305@oracle.com>
In-Reply-To: <49E2BEE2.8070305@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010204.49EA77B0.0053:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andres, how does this look to you?

It fixes the problems that I know about.



From: Randy Dunlap <randy.dunlap@oracle.com>

Fix multiple build errors due to cs553x-gpio using GPIO APIs
and using PCI APIs.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- mmotm-2009-0417-1519.orig/arch/x86/Kconfig
+++ mmotm-2009-0417-1519/arch/x86/Kconfig
@@ -1969,7 +1969,8 @@ config GEODE_MFGPT_TIMER
 
 config OLPC
 	bool "One Laptop Per Child support"
-	select GPIO_CS553X
+	select GPIO_CS553X if PCI
+	select GPIOLIB if PCI
 	default n
 	---help---
 	  Add support for detecting the unique features of the OLPC
