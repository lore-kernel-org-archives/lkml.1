Return-Path: <linux-kernel-owner+w=401wt.eu-S1753564AbXDIWeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbXDIWeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 18:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbXDIWeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 18:34:16 -0400
Received: from gw.goop.org ([64.81.55.164]:58581 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbXDIWeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 18:34:15 -0400
Message-ID: <461ABF63.3040703@goop.org>
Date: Mon, 09 Apr 2007 15:34:11 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: problem in 2.6.21-rc6-mm1: i386-enable-4k-stacks-by-default.patch?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- a/arch/i386/Kconfig.debug~i386-enable-4k-stacks-by-default
+++ a/arch/i386/Kconfig.debug
@@ -57,14 +57,16 @@ config DEBUG_RODATA
 	  If in doubt, say "N".
 
 config 4KSTACKS
-	bool "Use 4Kb for kernel stacks instead of 8Kb"
-	depends on DEBUG_KERNEL
+	bool "Use 4Kb for kernel stacks instead of 8Kb" if DEBUG_KERNEL
+	depends on n
+	default y


I don't see this option appear in my .config, and I guess its always
using 8k stacks.  If I remove the "depends on n", it does what I expect
it to do (ie, offers me the option).  Is "depends on n" supposed to do
something, or is it just a bogon?

    J
