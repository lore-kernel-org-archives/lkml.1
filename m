Return-Path: <linux-kernel-owner+w=401wt.eu-S933594AbZIPWkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933594AbZIPWkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933557AbZIPWkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:40:12 -0400
Received: from kroah.org ([198.145.64.141]:48939 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760328AbZIPWju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:39:50 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:37:15 2009
Message-Id: <20090916223714.964459375@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:36:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [patch 12/45] md: Fix "strchr" [drivers/md/dm-log-userspace.ko] undefined!
References: <20090916223613.597295240@mini.kroah.org>
Content-Disposition: inline; filename=md-fix-strchr-undefined.patch
In-Reply-To: <20090916223739.GA4789@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>

commit 0d03d59d9b31cd1e33b7e46a80b6fef66244b1f2 upstream.

Commit b8313b6da7e2e7c7f47d93d8561969a3ff9ba0ea ("dm log: remove incorrect
field from userspace table output") added a call to strstr() with a
single-character "needle" string parameter.

Unfortunately some versions of gcc replace such calls to strstr() by calls
to strchr() behind our back.  This causes linking errors if strchr() is
defined as an inline function in <asm/string.h> (e.g. on m68k):

| WARNING: "strchr" [drivers/md/dm-log-userspace.ko] undefined!

Avoid this by explicitly calling strchr() instead.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-log-userspace-base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-log-userspace-base.c
+++ b/drivers/md/dm-log-userspace-base.c
@@ -582,7 +582,7 @@ static int userspace_status(struct dm_di
 		break;
 	case STATUSTYPE_TABLE:
 		sz = 0;
-		table_args = strstr(lc->usr_argv_str, " ");
+		table_args = strchr(lc->usr_argv_str, ' ');
 		BUG_ON(!table_args); /* There will always be a ' ' */
 		table_args++;
 


