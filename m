Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbXFUXvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbXFUXvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 19:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750716AbXFUXvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 19:51:40 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35907 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751268AbXFUXvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 19:51:40 -0400
Date: Fri, 22 Jun 2007 01:51:59 +0200
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: [RFC: 2.6 patch] allow disabling DNOTIFY without EMBEDDED
Message-ID: <20070621235159.GE23017@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows disabling DNOTIFY with CIONFIG_EMBEDDED=n.

I'm currently running a kernel with dnotify disabled and I haven't run 
into any problem. Is there any popular application left that breaks 
without dnotify support in the kernel?

Note that this patch does not remove dnotify support, it still defaults
to "y", and the help text recommends enabling it.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc4-mm2/fs/Kconfig.old	2007-06-21 18:25:20.000000000 +0200
+++ linux-2.6.22-rc4-mm2/fs/Kconfig	2007-06-21 18:25:54.000000000 +0200
@@ -585,17 +585,17 @@
 	depends on XFS_QUOTA || QUOTA
 	default y
 
 config DNOTIFY
-	bool "Dnotify support" if EMBEDDED
+	bool "Dnotify support"
 	default y
 	help
 	  Dnotify is a directory-based per-fd file change notification system
 	  that uses signals to communicate events to user-space.  There exist
 	  superior alternatives, but some applications may still rely on
 	  dnotify.
 
-	  Because of this, if unsure, say Y.
+	  If unsure, say Y.
 
 config AUTOFS_FS
 	tristate "Kernel automounter support"
 	help

