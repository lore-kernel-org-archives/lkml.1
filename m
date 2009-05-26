Return-Path: <linux-kernel-owner+w=401wt.eu-S1757874AbZEZXds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874AbZEZXds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758254AbZEZXdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:33:21 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:57306 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757841AbZEZXdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:33:21 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Paul Mundt <lethal@linux-sh.org>,
       Greg Ungerer <gerg@uclinux.org>, uclinux-dev@uclinux.org,
       linux-mtd@lists.infradead.org
Subject: [PATCH 3/3] mtd/maps: uclinux: do not allow to be built as a module
Date: Tue, 26 May 2009 19:33:18 -0400
Message-Id: <1243380798-10089-3-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090526231902.GA6295@linux-sh.org>
References: <20090526231902.GA6295@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There isn't any benefit to building the uClinux MTD map as a module as the
rootfs it requires in order to actually be usable is appended to the
kernel image, not the module.  No known system builds it this way either,
so change the option to "bool".

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
CC: Paul Mundt <lethal@linux-sh.org>
CC: Greg Ungerer <gerg@uclinux.org>
CC: uclinux-dev@uclinux.org
CC: linux-mtd@lists.infradead.org
---
 drivers/mtd/maps/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
index 82923bd..907873b 100644
--- a/drivers/mtd/maps/Kconfig
+++ b/drivers/mtd/maps/Kconfig
@@ -501,7 +501,7 @@ config MTD_BFIN_ASYNC
 	  If compiled as a module, it will be called bfin-async-flash.
 
 config MTD_UCLINUX
-	tristate "Generic uClinux RAM/ROM filesystem support"
+	bool "Generic uClinux RAM/ROM filesystem support"
 	depends on MTD_PARTITIONS && MTD_RAM && !MMU
 	help
 	  Map driver to support image based filesystems for uClinux.
-- 
1.6.3.1

