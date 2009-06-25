Return-Path: <linux-kernel-owner+w=401wt.eu-S1755144AbZFYSHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144AbZFYSHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 14:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbZFYSHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 14:07:24 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:3394 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbZFYSHX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 14:07:23 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
From: "Leo (Hao) Chen" <leochen@broadcom.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "linux-arm@lists.arm.linux.org.uk" <linux-arm@lists.arm.linux.org.uk>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Date: Thu, 25 Jun 2009 11:07:18 -0700
Subject: BogoMIPS drops to 2/3 when CONFIG_MODULES is not set for an
 ARMv6 SoC platform
Thread-Topic: BogoMIPS drops to 2/3 when CONFIG_MODULES is not set for
 an ARMv6 SoC platform
Thread-Index: AQHJ9b/HUn4LCXAm/EKCZasLwNdjeg==
Message-ID: <8628FE4E7912BF47A96AE7DD7BAC0AADCB259D8717@SJEXCHCCR02.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 665D635D0EG4609485-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I encountered an interesting problem when I was porting the latest Linux kernel to our ARM11 based SoC.

I turned off the CONFIG_MODULES configuration option and the BogoMIPS drop to only 2/3 of the original number.

With the same kernel source code, when CONFIG_MODULES is turned on.
-----------------------
# cat /proc/cpuinfo 
Processor       : ARMv6-compatible processor rev 7 (v6l)
BogoMIPS        : 499.71
Features        : swp half thumb fastmult edsp java 
CPU implementer : 0x41
CPU architecture: 7
CPU variant     : 0x0
CPU part        : 0xb76
CPU revision    : 7

when CONFIG_MODULES is turned off.
# cat /proc/cpuinfo 
Processor       : ARMv6-compatible processor rev 7 (v6l)
BogoMIPS        : 332.59
Features        : swp half thumb fastmult edsp java 
CPU implementer : 0x41
CPU architecture: 7
CPU variant     : 0x0
CPU part        : 0xb76
CPU revision    : 7

The only difference between my two builds is the CONFIG_MODULES option.
--- .config.old 2009-06-24 16:32:21.000000000 -0700
+++ .config     2009-06-25 10:59:26.000000000 -0700
@@ -100,12 +99,7 @@
 CONFIG_HAVE_GENERIC_DMA_COHERENT=y
 CONFIG_RT_MUTEXES=y
 CONFIG_BASE_SMALL=0
-CONFIG_MODULES=y
-# CONFIG_MODULE_FORCE_LOAD is not set
-CONFIG_MODULE_UNLOAD=y
-# CONFIG_MODULE_FORCE_UNLOAD is not set
-# CONFIG_MODVERSIONS is not set
-# CONFIG_MODULE_SRCVERSION_ALL is not set
+# CONFIG_MODULES is not set
 CONFIG_BLOCK=y
 CONFIG_LBDAF=y
 # CONFIG_BLK_DEV_BSG is not set

Both the 2.6.30 and 2.6.27.18 kernel present the same problem.

Does anyone notice this interesting problem?  If yes, what's the explanation?  Why the BogoMIPS drops so much with just one configuration option.

Thanks,

Leo Chen
Software Engineer
Broadcom Canada
