Return-Path: <linux-kernel-owner+w=401wt.eu-S938750AbXHLU5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938750AbXHLU5x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 16:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934076AbXHLU5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 16:57:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:52798 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938619AbXHLU5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 16:57:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=o2c2UjgYASxkVQ4cydY27eqFwmrEQtTrzT1gX4gvflVSUN3hNUdEmHsqDmKlObhX2xaS34VbyY7uP9/CbOmxcbpdG/JAWv+1PhYRehwZf3jrY10VUVS/5p2cPY4pb3bPSHMytqK8+HrD3kzF4ldifEcriWiwIK+vplBljMirdq0=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] 4KSTACKS, move out of Kernel hacking menu (sh)
Date: Sun, 12 Aug 2007 22:54:48 +0200
User-Agent: KMail/1.9.7
Cc: Paul Mundt <lethal@linux-sh.org>, Jesper Juhl <jesper.juhl@gmail.com>
References: <200708122250.58773.jesper.juhl@gmail.com>
In-Reply-To: <200708122250.58773.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708122254.48657.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Since 4KSTACKS is nolonger a debug only feature, move it out of
the Kernel Hacking menu (sh).

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 54878f0..43e79f4 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -205,6 +205,15 @@ config CPU_HAS_PTEA
 config CPU_HAS_DSP
 	bool
 
+config 4KSTACKS
+	bool "Use 4Kb for kernel stacks instead of 8Kb"
+	help
+	  If you say Y here the kernel will use a 4Kb stacksize for the
+	  kernel stack attached to each process/thread. This facilitates
+	  running more threads on a system and also reduces the pressure
+	  on the VM subsystem for higher order allocations. This option
+	  will also use IRQ stacks to compensate for the reduced stackspace.
+
 endmenu
 
 menu "Board support"
diff --git a/arch/sh/Kconfig.debug b/arch/sh/Kconfig.debug
index 5bb4bd7..0c2992b 100644
--- a/arch/sh/Kconfig.debug
+++ b/arch/sh/Kconfig.debug
@@ -72,15 +72,6 @@ config DEBUG_STACK_USAGE
 
 	  This option will slow down process creation somewhat.
 
-config 4KSTACKS
-	bool "Use 4Kb for kernel stacks instead of 8Kb"
-	help
-	  If you say Y here the kernel will use a 4Kb stacksize for the
-	  kernel stack attached to each process/thread. This facilitates
-	  running more threads on a system and also reduces the pressure
-	  on the VM subsystem for higher order allocations. This option
-	  will also use IRQ stacks to compensate for the reduced stackspace.
-
 config SH_KGDB
 	bool "Include KGDB kernel debugger"
 	select FRAME_POINTER


