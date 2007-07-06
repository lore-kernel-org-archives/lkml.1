Return-Path: <linux-kernel-owner+w=401wt.eu-S1763602AbXGFPwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763602AbXGFPwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 11:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757948AbXGFPwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 11:52:25 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:36359 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757220AbXGFPwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 11:52:24 -0400
Date: Fri, 6 Jul 2007 17:52:23 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Adrian 'Trivial' Bunk" <trivial@kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Hiroaki Fuse <Hiroaki_Fuse@hq.scei.sony.co.jp>
Subject: [PATCH] compat32: ignore the LOOP_CLR_FD ioctl
In-Reply-To: <jevecxhep6.fsf@sykes.suse.de>
Message-ID: <Pine.LNX.4.62.0707061749250.17331@pademelon.sonytel.be>
References: <Pine.LNX.4.62.0707061431360.1203@pademelon.sonytel.be>
 <jevecxhep6.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-1022588381-1183737050=:17331"
Content-ID: <Pine.LNX.4.62.0707061751550.17331@pademelon.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-1022588381-1183737050=:17331
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.62.0707061751551.17331@pademelon.sonytel.be>

compat32: Ignore the LOOP_CLR_FD ioctl for the loop block device, to kill an
annoying kernel message when e.g. busybox umount is used.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 fs/compat_ioctl.c |    4 ++++
 1 files changed, 4 insertions(+)

--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -63,6 +63,7 @@
 #include <linux/wireless.h>
 #include <linux/atalk.h>
 #include <linux/blktrace_api.h>
+#include <linux/loop.h>
 
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci.h>
@@ -3489,6 +3490,9 @@ HANDLE_IOCTL(LPSETTIMEOUT, lp_timeout_tr
 
 IGNORE_IOCTL(VFAT_IOCTL_READDIR_BOTH32)
 IGNORE_IOCTL(VFAT_IOCTL_READDIR_SHORT32)
+
+/* loop */
+IGNORE_IOCTL(LOOP_CLR_FD)
 };
 
 #define IOCTL_HASHSIZE 256

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584337861-1022588381-1183737050=:17331--
