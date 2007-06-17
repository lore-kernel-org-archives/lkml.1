Return-Path: <linux-kernel-owner+w=401wt.eu-S1759527AbXFQL4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759527AbXFQL4i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 07:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758176AbXFQL4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 07:56:32 -0400
Received: from aun.it.uu.se ([130.238.12.36]:54776 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758169AbXFQL4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 07:56:31 -0400
Date: Sun, 17 Jun 2007 13:56:07 +0200 (MEST)
Message-Id: <200706171156.l5HBu7Vs025573@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: neilb@suse.de
Subject: [PATCH 2.6.22-rc5] nfsd: fix pointer-to-int cast warning
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

nfsctl.c:write_getfs() open-codes offsetof, but does it poorly
resulting in the following warning on 64-bit machines:

fs/nfsd/nfsctl.c: In function 'write_getfs':
fs/nfsd/nfsctl.c:248: warning: cast from pointer to integer of different size

Fix: use offsetof().

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>

--- linux-2.6.22-rc5/fs/nfsd/nfsctl.c.~1~	2007-04-26 14:59:37.000000000 +0200
+++ linux-2.6.22-rc5/fs/nfsd/nfsctl.c	2007-06-17 13:30:32.000000000 +0200
@@ -245,7 +245,7 @@ static ssize_t write_getfs(struct file *
 	}
 	exp_readunlock();
 	if (err == 0)
-		err = res->fh_size + (int)&((struct knfsd_fh*)0)->fh_base;
+		err = res->fh_size + offsetof(struct knfsd_fh, fh_base);
  out:
 	return err;
 }
