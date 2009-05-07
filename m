Return-Path: <linux-kernel-owner+w=401wt.eu-S1755683AbZEGCP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbZEGCP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 22:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbZEGCPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 22:15:50 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:33688 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbZEGCPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 22:15:50 -0400
Message-ID: <4A02446F.6090303@oracle.com>
Date: Wed, 06 May 2009 19:16:15 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, samr <sam@ravnborg.org>
Subject: [PATCH v2] menu: fix embedded menu presentation
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt007.oracle.com [141.146.116.16]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010208.4A024406.012F:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

The STRIP_ASM_SYMS kconfig symbol mucks up the embedded menu
because STRIP_ASM_SYMS is in the middle of the embedded menu items
but it does not depend on EMBEDDED.  Move it to beyond the end
of the embedded menu so that the menu is presented correctly.

or if STRIP_ASM_SYMS should depend on EMBEDDED, that can also
be fixed.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 init/Kconfig |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- linux-2.6.30-rc4-git3.orig/init/Kconfig
+++ linux-2.6.30-rc4-git3/init/Kconfig
@@ -808,14 +808,6 @@ config KALLSYMS_EXTRA_PASS
 	   you wait for kallsyms to be fixed.
 
 
-config STRIP_ASM_SYMS
-	bool "Strip assembler-generated symbols during link"
-	default n
-	help
-	  Strip internal assembler-generated symbols during a link (symbols
-	  that look like '.Lxxx') so they don't pollute the output of
-	  get_wchan() and suchlike.
-
 config HOTPLUG
 	bool "Support for hot-pluggable devices" if EMBEDDED
 	default y
@@ -961,6 +953,14 @@ config SLUB_DEBUG
 	  SLUB sysfs support. /sys/slab will not exist and there will be
 	  no support for cache validation etc.
 
+config STRIP_ASM_SYMS
+	bool "Strip assembler-generated symbols during link"
+	default n
+	help
+	  Strip internal assembler-generated symbols during a link (symbols
+	  that look like '.Lxxx') so they don't pollute the output of
+	  get_wchan() and suchlike.
+
 config COMPAT_BRK
 	bool "Disable heap randomization"
 	default y
