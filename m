Return-Path: <linux-kernel-owner+w=401wt.eu-S1758101AbXH0Q5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101AbXH0Q5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 12:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbXH0Q45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 12:56:57 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:21883 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbXH0Q44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 12:56:56 -0400
Date: Mon, 27 Aug 2007 16:04:39 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Len Brown <len.brown@intel.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] reverse CONFIG_ACPI_PROC_EVENT default
Message-ID: <Pine.LNX.4.64.0708271602170.21853@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sigh.  Again an ACPI assault on the Thinkpad's Fn+F4 to suspend to RAM.
The default and text for CONFIG_THINKPAD_ACPI_INPUT_ENABLED were fixed
in -rc3, but now 14e04fb34ffa82ee61ae69f98d8fca12d2e8e31c introduces
CONFIG_ACPI_PROC_EVENT default n to disable it again.  Change default
to y, and add comment to make it clearer that n is for future distros.

Signed-off-by: Hugh Dickins <hugh@veritas.com>

--- 2.6.23-rc3-git10/drivers/acpi/Kconfig	2007-08-26 18:10:15.000000000 +0100
+++ linux/drivers/acpi/Kconfig	2007-08-26 18:59:16.000000000 +0100
@@ -71,6 +71,7 @@ config ACPI_PROCFS
 config ACPI_PROC_EVENT
 	bool "Deprecated /proc/acpi/event support"
 	depends on PROC_FS
+	default y
 	---help---
 	  A user-space daemon, acpi, typically read /proc/acpi/event
 	  and handled all ACPI sub-system generated events.
@@ -78,10 +79,13 @@ config ACPI_PROC_EVENT
 	  These events are now delivered to user-space via
 	  either the input layer, or as netlink events.
 
-	  This build option enables the old code for for legacy
+	  This build option enables the old code for legacy
 	  user-space implementation.  After some time, this will
 	  be moved under CONFIG_ACPI_PROCFS, and then deleted.
 
+	  Say Y here to retain the old behaviour.  Say N if your
+	  user-space is newer than kernel 2.6.23 (September 2007).
+
 config ACPI_AC
 	tristate "AC Adapter"
 	depends on X86
