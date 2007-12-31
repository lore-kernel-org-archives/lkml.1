Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbXLaSGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbXLaSGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 13:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbXLaSGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 13:06:17 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:36385 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbXLaSGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 13:06:15 -0500
Date: Mon, 31 Dec 2007 10:05:34 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, gregkh@suse.de
Subject: [PATCH] sysfs: make SYSFS_DEPRECATED depend on SYSFS
Message-Id: <20071231100534.dcbed808.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Make SYSFS_DEPRECATED depend on SYSFS since files that check
CONFIG_SYSFS_DEPRECATED don't check for CONFIG_SYSFS first.
Also don't prompt user about SYSFS_DEPRECATED if SYSFS=n.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 init/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.24-rc6-mm1.orig/init/Kconfig
+++ linux-2.6.24-rc6-mm1/init/Kconfig
@@ -349,6 +349,7 @@ config RESOURCE_COUNTERS
 
 config SYSFS_DEPRECATED
 	bool "Create deprecated sysfs files"
+	depends on SYSFS
 	default y
 	help
 	  This option creates deprecated symlinks such as the
