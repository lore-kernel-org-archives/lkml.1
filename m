Return-Path: <linux-kernel-owner+w=401wt.eu-S1765972AbYDYSF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765972AbYDYSF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764828AbYDYR5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 13:57:34 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:53137 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762572AbYDYR5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 13:57:23 -0400
Date: Fri, 25 Apr 2008 13:56:16 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: [PATCH 16/19] UML - Fix CONFIG_RAW dependencies
Message-ID: <20080425175616.GA11202@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert P. J. Day <rpjday@crashcourse.ca>

Add the BLOCK dependency for RAW_DRIVER, to match what's in
drivers/char/Kconfig.  Also, while we're there, update the alleged
obsolesence of RAW_DRIVER since it doesn't seem to be going away any
time soon.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/Kconfig.char |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.22/arch/um/Kconfig.char
===================================================================
--- linux-2.6.22.orig/arch/um/Kconfig.char	2008-02-20 11:23:30.000000000 -0500
+++ linux-2.6.22/arch/um/Kconfig.char	2008-03-07 11:57:18.000000000 -0500
@@ -145,14 +145,14 @@ config LEGACY_PTYS
 	  systems, it is safe to say N.
 
 config RAW_DRIVER
-        tristate "RAW driver (/dev/raw/rawN) (OBSOLETE)"
+        tristate "RAW driver (/dev/raw/rawN)"
+	depends on BLOCK
         help
           The raw driver permits block devices to be bound to /dev/raw/rawN.
           Once bound, I/O against /dev/raw/rawN uses efficient zero-copy I/O.
           See the raw(8) manpage for more details.
 
-          The raw driver is deprecated and will be removed soon.
-          Applications should simply open the device (eg /dev/hda1)
+          Applications should preferably open the device (eg /dev/hda1)
           with the O_DIRECT flag.
 
 config MAX_RAW_DEVS
