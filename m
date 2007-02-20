Return-Path: <linux-kernel-owner+w=401wt.eu-S1030282AbXBTREi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030282AbXBTREi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 12:04:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030299AbXBTREi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 12:04:38 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:54975 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030282AbXBTREh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 12:04:37 -0500
Date: Tue, 20 Feb 2007 11:56:37 -0500
From: Jeff Dike <jdike@addtoit.com>
To: akpm@osdl.org
Cc: Allan Graves <allan.graves@gmail.com>, linux-kernel@vger.kernel.org,
       user-mode-linux@lists.sourceforge.net
Subject: [PATCH 1/3] UML - Enable RAW
Message-ID: <20070220165636.GA6246@ccure.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Allan Graves <allan.graves@gmail.com>
Date:   Fri Jan 26 17:49:00 2007

    [PATCH] Enable raw.ko in UML
        - This patch adds the RAW device driver options to the UML
Kconfig.char file so that you may use them in UML.

Signed-off-by: Allan Graves<allan.graves@gmail.com>
Signed-off-by: Jeff Dike <jdike@addtoit.com>
--
 arch/um/Kconfig.char |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

Index: linux-2.6.18-mm/arch/um/Kconfig.char
===================================================================
--- linux-2.6.18-mm.orig/arch/um/Kconfig.char	2007-01-17 06:02:47.000000000 -0500
+++ linux-2.6.18-mm/arch/um/Kconfig.char	2007-01-23 11:29:06.000000000 -0500
@@ -146,6 +146,25 @@ config LEGACY_PTYS
 	  security.  This option enables these legacy devices; on most
 	  systems, it is safe to say N.
 
+config RAW_DRIVER
+        tristate "RAW driver (/dev/raw/rawN) (OBSOLETE)"
+        help
+          The raw driver permits block devices to be bound to /dev/raw/rawN.
+          Once bound, I/O against /dev/raw/rawN uses efficient zero-copy I/O.
+          See the raw(8) manpage for more details.
+
+          The raw driver is deprecated and will be removed soon.
+          Applications should simply open the device (eg /dev/hda1)
+          with the O_DIRECT flag.
+
+config MAX_RAW_DEVS
+        int "Maximum number of RAW devices to support (1-8192)"
+        depends on RAW_DRIVER
+        default "256"
+        help
+          The maximum number of RAW devices that are supported.
+          Default is 256. Increase this number in case you need lots of
+          raw devices.
 
 config LEGACY_PTY_COUNT
 	int "Maximum number of legacy PTY in use"

-- 
Work email - jdike at linux dot intel dot com
