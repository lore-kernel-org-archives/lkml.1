Return-Path: <linux-kernel-owner+w=401wt.eu-S1754204AbYJDU4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbYJDU4l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 16:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbYJDU4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 16:56:33 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:14099 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbYJDU4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 16:56:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=CW2YPhHd9HyPsAOd0zakfWhh49ihaxZCU6eZUcsXEDi9pm4kH1IBZCaeEWStt6jpxy
         1kdxbm+PClG0sKAZrZTeBkQP/BQnzNcHJqToajZONjjhw+y2bt6Aa4803hGa5HYYLVcj
         KNi2GduPrMh6Pvbn19KJMg3UzzHp4Z670OAV8=
Date: Sun, 5 Oct 2008 00:58:57 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mpm@selenic.com
Subject: [PATCH] proc: move PROC_PAGE_MONITOR to fs/proc/Kconfig
Message-ID: <20081004205857.GB4259@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI, applied to proc.git.

commit 2ee80fd74e64b07815e828b67d3343fce6063e14
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Fri Oct 3 02:01:51 2008 +0400

    proc: move PROC_PAGE_MONITOR to fs/proc/Kconfig
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

diff --git a/fs/proc/Kconfig b/fs/proc/Kconfig
index 73cd7a4..50f8f06 100644
--- a/fs/proc/Kconfig
+++ b/fs/proc/Kconfig
@@ -57,3 +57,13 @@ config PROC_SYSCTL
 	  As it is generally a good thing, you should say Y here unless
 	  building a kernel for install/rescue disks or your system is very
 	  limited in memory.
+
+config PROC_PAGE_MONITOR
+ 	default y
+	depends on PROC_FS && MMU
+	bool "Enable /proc page monitoring" if EMBEDDED
+ 	help
+	  Various /proc files exist to monitor process memory utilization:
+	  /proc/pid/smaps, /proc/pid/clear_refs, /proc/pid/pagemap,
+	  /proc/kpagecount, and /proc/kpageflags. Disabling these
+          interfaces will reduce the size of the kernel by approximately 4kb.
diff --git a/init/Kconfig b/init/Kconfig
index c11da38..8a8e2d0 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -779,16 +779,6 @@ config MARKERS
 
 source "arch/Kconfig"
 
-config PROC_PAGE_MONITOR
- 	default y
-	depends on PROC_FS && MMU
-	bool "Enable /proc page monitoring" if EMBEDDED
- 	help
-	  Various /proc files exist to monitor process memory utilization:
-	  /proc/pid/smaps, /proc/pid/clear_refs, /proc/pid/pagemap,
-	  /proc/kpagecount, and /proc/kpageflags. Disabling these
-          interfaces will reduce the size of the kernel by approximately 4kb.
-
 endmenu		# General setup
 
 config HAVE_GENERIC_DMA_COHERENT
