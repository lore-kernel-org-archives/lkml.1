Return-Path: <linux-kernel-owner+w=401wt.eu-S1753030AbXC1MMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbXC1MMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 08:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbXC1ML7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 08:11:59 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36846 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933204AbXC1MLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 08:11:42 -0400
Date: Wed, 28 Mar 2007 14:11:41 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>, dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: [-mm patch] drivers/mtd/ubi/: make code static
Message-ID: <20070328121141.GQ16477@stusta.de>
References: <20070326205706.a750bb35.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070326205706.a750bb35.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 08:57:06PM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.21-rc4-mm1:
>...
>  git-ubi.patch
>...
>  git trees
>...


This patch makes needlessly global code static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/mtd/ubi/eba.c  |    4 ++--
 drivers/mtd/ubi/vtbl.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.21-rc5-mm2/drivers/mtd/ubi/eba.c.old	2007-03-27 23:36:48.000000000 +0200
+++ linux-2.6.21-rc5-mm2/drivers/mtd/ubi/eba.c	2007-03-27 23:38:05.000000000 +0200
@@ -489,8 +489,8 @@ out_unlock:
  * Returns new physical eraseblock number in case of success, and a negative
  * error code in case of failure.
  */
-int recover_peb(struct ubi_device *ubi, int pnum, int vol_id, int lnum,
-		const void *buf, int offset, int len)
+static int recover_peb(struct ubi_device *ubi, int pnum, int vol_id, int lnum,
+		       const void *buf, int offset, int len)
 {
 	int err, idx = vol_id2idx(ubi, vol_id), new_pnum, data_size, tries = 0;
 	struct ubi_volume *vol = ubi->volumes[idx];
--- linux-2.6.21-rc5-mm2/drivers/mtd/ubi/vtbl.c.old	2007-03-27 23:38:54.000000000 +0200
+++ linux-2.6.21-rc5-mm2/drivers/mtd/ubi/vtbl.c	2007-03-27 23:39:08.000000000 +0200
@@ -68,7 +68,7 @@ static void paranoid_vtbl_check(const st
 #endif
 
 /* Empty volume table record */
-struct ubi_vtbl_record empty_vtbl_record;
+static struct ubi_vtbl_record empty_vtbl_record;
 
 /**
  * ubi_change_vtbl_record - change volume table record.

