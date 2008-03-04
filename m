Return-Path: <linux-kernel-owner+w=401wt.eu-S935329AbYCDXYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935329AbYCDXYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 18:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934850AbYCDXTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 18:19:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42783 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934281AbYCDXTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 18:19:04 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Kay Sievers <kay.sievers@vrfy.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/8] sysfs: CONFIG_SYSFS_DEPRECATED fix
Date: Tue,  4 Mar 2008 15:18:46 -0800
Message-Id: <1204672732-3127-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <20080304231519.GC3073@suse.de>
References: <20080304231519.GC3073@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

CONFIG_SYSFS_DEPRECATED=y changed its meaning recently and causes
regressions in working setups that had SYSFS_DEPRECATED disabled.

so rename it to SYSFS_DEPRECATED_V2 so that testers pick up the new
default via 'make oldconfig', even if their old .config's disabled
CONFIG_SYSFS_DEPRECATED ...

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 init/Kconfig |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index e6606e6..98ebf37 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -367,9 +367,13 @@ config RESOURCE_COUNTERS
 	depends on CGROUPS
 
 config SYSFS_DEPRECATED
+	bool
+
+config SYSFS_DEPRECATED_V2
 	bool "Create deprecated sysfs files"
 	depends on SYSFS
 	default y
+	select SYSFS_DEPRECATED
 	help
 	  This option creates deprecated symlinks such as the
 	  "device"-link, the <subsystem>:<name>-link, and the
-- 
1.5.4.3

