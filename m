Return-Path: <linux-kernel-owner+w=401wt.eu-S938297AbXFHHWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938297AbXFHHWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937856AbXFHHRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:17:44 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:33213 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937991AbXFHHRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:17:42 -0400
Message-Id: <20070608071540.351429000@sous-sol.org>
References: <20070608071511.159309000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:15:22 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Miklos Szeredi <miklos@szeredi.hu>,
       Miklos Szeredi <mszeredi@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 11/32] fuse: fix mknod of regular file
Content-Disposition: inline; filename=fuse-fix-mknod-of-regular-file.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Miklos Szeredi <mszeredi@suse.cz>

The wrong lookup flag was tested in ->create() causing havoc (error or
Oops) when a regular file was created with mknod() in a fuse
filesystem.

Thanks to J. Cameijo Cerdeira for the report.

Kernels 2.6.18 onward are affected.  Please apply to -stable as well.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/fuse/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.20.13.orig/fs/fuse/dir.c
+++ linux-2.6.20.13/fs/fuse/dir.c
@@ -484,7 +484,7 @@ static int fuse_mknod(struct inode *dir,
 static int fuse_create(struct inode *dir, struct dentry *entry, int mode,
 		       struct nameidata *nd)
 {
-	if (nd && (nd->flags & LOOKUP_CREATE)) {
+	if (nd && (nd->flags & LOOKUP_OPEN)) {
 		int err = fuse_create_open(dir, entry, mode, nd);
 		if (err != -ENOSYS)
 			return err;

-- 
