Return-Path: <linux-kernel-owner+w=401wt.eu-S1759892AbZDDIqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892AbZDDIqN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 04:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755651AbZDDIp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 04:45:56 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:49532 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbZDDIpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 04:45:55 -0400
Message-ID: <49D71E3C.5080701@larces.uece.br>
Date: Sat, 04 Apr 2009 05:45:48 -0300
From: Sergio Luis <sergio@larces.uece.br>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Pavel Machek" <pavel@suse.cz>,
       "x86 Maintainers" <x86@kernel.org>, "Ingo Molnar" <mingo@elte.hu>
Subject: [PATCH 1/6] x86: unify power/cpu_(32|64) headers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: unify power/cpu_(32|64) headers

First step towards the unification of cpu_32.c and cpu_64.c.
This commit unifies the headers of such files, making both
of them use the same header files. It also remove the uneeded
<module.h>.

Signed-off-by: Sergio Luis <sergio@larces.uece.br>
Signed-off-by: Lauro Salmito <laurosalmito@gmail.com>
---
 arch/x86/power/cpu_32.c |    6 +++++-
 arch/x86/power/cpu_64.c |    8 +++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/power/cpu_32.c b/arch/x86/power/cpu_32.c
index 274d060..e9ceaa0 100644
--- a/arch/x86/power/cpu_32.c
+++ b/arch/x86/power/cpu_32.c
@@ -7,9 +7,13 @@
  * Copyright (c) 2001 Patrick Mochel <mochel@osdl.org>
  */
 
-#include <linux/module.h>
 #include <linux/suspend.h>
+#include <linux/smp.h>
+
+#include <asm/pgtable.h>
+#include <asm/proto.h>
 #include <asm/mtrr.h>
+#include <asm/page.h>
 #include <asm/mce.h>
 #include <asm/xcr.h>
 
diff --git a/arch/x86/power/cpu_64.c b/arch/x86/power/cpu_64.c
index e3b6cf7..d1cf7ae 100644
--- a/arch/x86/power/cpu_64.c
+++ b/arch/x86/power/cpu_64.c
@@ -8,12 +8,14 @@
  * Copyright (c) 2001 Patrick Mochel <mochel@osdl.org>
  */
 
-#include <linux/smp.h>
 #include <linux/suspend.h>
-#include <asm/proto.h>
-#include <asm/page.h>
+#include <linux/smp.h>
+
 #include <asm/pgtable.h>
+#include <asm/proto.h>
 #include <asm/mtrr.h>
+#include <asm/page.h>
+#include <asm/mce.h>
 #include <asm/xcr.h>
 
 static void fix_processor_context(void);
