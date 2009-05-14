Return-Path: <linux-kernel-owner+w=401wt.eu-S1760041AbZENW5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760041AbZENW5v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 18:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756789AbZENWm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:42:58 -0400
Received: from kroah.org ([198.145.64.141]:52693 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279AbZENWmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:42:36 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:35:27 2009
Message-Id: <20090514223527.746455880@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:33:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Miklos Szeredi <mszeredi@suse.cz>
Subject: [patch 45/51] fuse: destroy bdi on error
References: <20090514223235.348540705@mini.kroah.org>
Content-Disposition: inline; filename=fuse-destroy-bdi-on-error.patch
In-Reply-To: <20090514223755.GA27019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit fd9db7297749c05fcf5721ce5393a5a8b8772f2a upstream.

Destroy bdi on error in fuse_fill_super().

This was an omission from commit 26c3679101dbccc054dcf370143941844ba70531
"fuse: destroy bdi on umount", which moved the bdi_destroy() call from
fuse_conn_put() to fuse_put_super().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/fuse/inode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -908,6 +908,7 @@ static int fuse_fill_super(struct super_
  err_put_root:
 	dput(root_dentry);
  err_put_conn:
+	bdi_destroy(&fc->bdi);
 	fuse_conn_put(fc);
  err_fput:
 	fput(file);


