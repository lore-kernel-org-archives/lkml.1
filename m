Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbXKFHgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbXKFHgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 02:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbXKFHgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 02:36:32 -0500
Received: from pip10.gyao.ne.jp ([61.122.117.248]:16660 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751441AbXKFHgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 02:36:31 -0500
Date: Tue, 6 Nov 2007 16:36:20 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] md: dm-mpath-hp-sw depends on scsi
Message-ID: <20071106073620.GA5258@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_SCSI=n __scsi_print_sense() is never linked in.

drivers/built-in.o: In function `hp_sw_end_io':
dm-mpath-hp-sw.c:(.text+0x914f8): undefined reference to `__scsi_print_sense'

Caught with a randconfig on current git.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 drivers/md/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 9b6fbf0..3fa7c77 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -269,7 +269,7 @@ config DM_MULTIPATH_RDAC
 
 config DM_MULTIPATH_HP
         tristate "HP MSA multipath support (EXPERIMENTAL)"
-        depends on DM_MULTIPATH && BLK_DEV_DM && EXPERIMENTAL
+        depends on DM_MULTIPATH && BLK_DEV_DM && SCSI && EXPERIMENTAL
         ---help---
           Multipath support for HP MSA (Active/Passive) series hardware.
 
