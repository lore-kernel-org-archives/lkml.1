Return-Path: <linux-kernel-owner+w=401wt.eu-S1761542AbYBNUyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761542AbYBNUyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbYBNUyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:54:15 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:44617 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbYBNUyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:54:14 -0500
Date: Thu, 14 Feb 2008 15:54:04 -0500
Message-Id: <200802142054.m1EKs49x023091@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] unhide CONFIG_DEBUG_SECTION_MISMATCH
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using: v2.6.25-rc1-120-ge760e71

In a normal compilation, I might this message:

...
  MODPOST vmlinux.o
WARNING: modpost: Found 4 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
...

I can indeed try to re-make, passing CONFIG_DEBUG_SECTION_MISMATCH=y on the
command line, but I can't turn on the option in my .config.  That's because
the option depends on "UNDEFINED".  (Was that an attempt to "hide" the
option?  Why?)  The following small patch allows me to set the option in my
.config.

Cheers,
Erez.



Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index a370fe8..3399d9d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -81,7 +81,6 @@ config HEADERS_CHECK
 
 config DEBUG_SECTION_MISMATCH
 	bool "Enable full Section mismatch analysis"
-	depends on UNDEFINED
 	help
 	  The section mismatch analysis checks if there are illegal
 	  references from one section to another section.
