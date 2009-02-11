Return-Path: <linux-kernel-owner+w=401wt.eu-S1757628AbZBKRLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628AbZBKRLu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 12:11:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754337AbZBKRLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 12:11:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:50203 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbZBKRLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 12:11:41 -0500
Subject: [PATCH] Don't override CONFIG_64BIT for ARCH={i386,x86_64} builds
From: David Woodhouse <dwmw2@infradead.org>
To: x86 maintainers <x86@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Wed, 11 Feb 2009 17:11:38 +0000
Message-Id: <1234372298.3586.23.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is a steaming great pain in the arse when the value of CONFIG_64BIT
explicitly written in my .config file is overridden by the value of
$ARCH inferred from the environment.

If I have a 32-bit .config and I happen to build it without remembering
to put 'ARCH=i386' on the make command line, it shouldn't force
CONFIG_64BIT=y and reconfigure.

This patch should fix that, while still allowing defconfig to work as it
currently does for both 32-bit and 64-bit environments, and still giving
the default value of CONFIG_64BIT according to $ARCH. It's just that it
won't _force_ a change to CONFIG_64BIT when it's set to something other
than what $ARCH would imply.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 73f7fe8..516046d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -3,7 +3,7 @@ mainmenu "Linux Kernel Configuration for x86"
 
 # Select 32 or 64 bit
 config 64BIT
-	bool "64-bit kernel" if ARCH = "x86"
+	bool "64-bit kernel"
 	default ARCH = "x86_64"
 	help
 	  Say yes to build a 64-bit kernel - formerly known as x86_64

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

