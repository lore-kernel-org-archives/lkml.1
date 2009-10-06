Return-Path: <linux-kernel-owner+w=401wt.eu-S1756390AbZJFF5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390AbZJFF5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 01:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756132AbZJFF5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 01:57:52 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:43150 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850AbZJFF5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 01:57:52 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2] firmware: only allow EDD on x86/x86_64
Date: Tue,  6 Oct 2009 01:57:07 -0400
Message-Id: <1254808627-3889-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc2
In-Reply-To: <1254808534-3793-1-git-send-email-vapier@gentoo.org>
References: <1254808534-3793-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than have the EDD depend on !ia64 (and assuming that only ia64,
x86, x86_64 will be including this Kconfig), have EDD depend on the only
arches which can support this code.  This should allow all other arches
to cleanly include the firmware Kconfig.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
v2
	- send out the right file this time

 drivers/firmware/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index ebb9e51..7fff33f 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -7,7 +7,7 @@ menu "Firmware Drivers"
 
 config EDD
 	tristate "BIOS Enhanced Disk Drive calls determine boot disk"
-	depends on !IA64
+	depends on (X86_64 || X86_32)
 	help
 	  Say Y or M here if you want to enable BIOS Enhanced Disk Drive
 	  Services real mode BIOS calls to determine which disk
-- 
1.6.5.rc2

