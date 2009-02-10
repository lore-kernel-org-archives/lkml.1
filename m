Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240AbZBJHf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbZBJHf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 02:35:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbZBJHfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 02:35:50 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38201 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbZBJHft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 02:35:49 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-next <linux-next@vger.kernel.org>,
       linux-ia64 <linux-ia64@vger.kernel.org>,
       Tony Luck <tony.luck@intel.com>, Jack Steiner <steiner@sgi.com>
Subject: [PATCH] don't compile SGI XP/GRU on ia64_generic
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20090210162821.6FC1.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 10 Feb 2009 16:35:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix build error

Currently sgi-xp driver depend on "uv.h" header file.
but only x86 have "uv.h" header.

Then, ia64 hit following build error.

  In file included from drivers/misc/sgi-gru/grufile.c:39:
  drivers/misc/sgi-gru/gru.h:22:23: error: asm/uv/uv.h: No such file or directory

Cc: Jack Steiner <steiner@sgi.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---
 drivers/misc/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/misc/Kconfig
===================================================================
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -165,7 +165,7 @@ config SGI_XP
 	depends on (IA64_GENERIC || IA64_SGI_SN2 || IA64_SGI_UV || X86_UV) && SMP
 	select IA64_UNCACHED_ALLOCATOR if IA64_GENERIC || IA64_SGI_SN2
 	select GENERIC_ALLOCATOR if IA64_GENERIC || IA64_SGI_SN2
-	select SGI_GRU if (IA64_GENERIC || IA64_SGI_UV || X86_64) && SMP
+	select SGI_GRU if (IA64_SGI_UV || X86_UV) && SMP
 	---help---
 	  An SGI machine can be divided into multiple Single System
 	  Images which act independently of each other and have
@@ -189,7 +189,7 @@ config HP_ILO
 
 config SGI_GRU
 	tristate "SGI GRU driver"
-	depends on (X86_UV || IA64_SGI_UV || IA64_GENERIC) && SMP
+	depends on (X86_UV || IA64_SGI_UV) && SMP
 	default n
 	select MMU_NOTIFIER
 	---help---


