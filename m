Return-Path: <linux-kernel-owner+w=401wt.eu-S1754976AbZBJMD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbZBJMD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 07:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbZBJMDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 07:03:46 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35988 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917AbZBJMDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 07:03:44 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Jack Steiner <steiner@sgi.com>
Subject: [PATCH 2/2] don't compile SGI XP/GRU on ia64_generic
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-next <linux-next@vger.kernel.org>,
       linux-ia64 <linux-ia64@vger.kernel.org>,
       Tony Luck <tony.luck@intel.com>, Dean Nelson <dcn@sgi.com>
In-Reply-To: <20090210162821.6FC1.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20090210162821.6FC1.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20090210210110.7001.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 10 Feb 2009 21:03:40 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] ia64: don't compile SGI-XP on ia64 generic.
Impact: fix build error

Currently sgi-xp driver depend on "uv.h" header file.
but only x86 have "uv.h" header.

Then, ia64 hit following build error.

  In file included from drivers/misc/sgi-xp/xp_main.c:19:
  drivers/misc/sgi-xp/xp.h:18:23: error: asm/uv/uv.h: No such file or directory
  make[3]: *** [drivers/misc/sgi-xp/xp_main.o] Error 1
  make[2]: *** [drivers/misc/sgi-xp] Error 2

Cc: Jack Steiner <steiner@sgi.com>
Cc: Dean Nelson <dcn@sgi.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 drivers/misc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/misc/Kconfig
===================================================================
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -162,7 +162,7 @@ config ENCLOSURE_SERVICES
 config SGI_XP
 	tristate "Support communication between SGI SSIs"
 	depends on NET
-	depends on (IA64_GENERIC || IA64_SGI_SN2 || IA64_SGI_UV || X86_UV) && SMP
+	depends on (IA64_SGI_SN2 || IA64_SGI_UV || X86_UV) && SMP
 	select IA64_UNCACHED_ALLOCATOR if IA64_GENERIC || IA64_SGI_SN2
 	select GENERIC_ALLOCATOR if IA64_GENERIC || IA64_SGI_SN2
 	select SGI_GRU if (IA64_SGI_UV || X86_UV) && SMP


