Return-Path: <linux-kernel-owner+w=401wt.eu-S1761929AbXLMOm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761929AbXLMOm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 09:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761682AbXLMOmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 09:42:43 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761661AbXLMOmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 09:42:42 -0500
Date: Thu, 13 Dec 2007 14:42:36 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>
Subject: [2.6.24 PATCH 02/06] dm mpath: hp requires scsi
Message-ID: <20071213144236.GU24157@agk.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Paul Mundt <lethal@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mundt <lethal@linux-sh.org>

With CONFIG_SCSI=n __scsi_print_sense() is never linked in.

drivers/built-in.o: In function `hp_sw_end_io':
dm-mpath-hp-sw.c:(.text+0x914f8): undefined reference to `__scsi_print_sense'

Caught with a randconfig on current git.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---

 drivers/md/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.24-rc5/drivers/md/Kconfig
===================================================================
--- linux-2.6.24-rc5.orig/drivers/md/Kconfig	2007-12-12 15:40:33.000000000 +0000
+++ linux-2.6.24-rc5/drivers/md/Kconfig	2007-12-12 15:43:10.000000000 +0000
@@ -269,7 +269,7 @@ config DM_MULTIPATH_RDAC
 
 config DM_MULTIPATH_HP
         tristate "HP MSA multipath support (EXPERIMENTAL)"
-        depends on DM_MULTIPATH && BLK_DEV_DM && EXPERIMENTAL
+        depends on DM_MULTIPATH && BLK_DEV_DM && SCSI && EXPERIMENTAL
         ---help---
           Multipath support for HP MSA (Active/Passive) series hardware.
 
