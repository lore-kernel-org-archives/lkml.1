Return-Path: <linux-kernel-owner+w=401wt.eu-S1757582AbZAaCr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582AbZAaCr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 21:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbZAaCqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:46:36 -0500
Received: from kroah.org ([198.145.64.141]:54719 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752676AbZAaCqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:46:35 -0500
Date: Fri, 30 Jan 2009 18:39:32 -0800
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
       alan@lxorguk.ukuu.org.uk, Dan Carpenter <error27@gmail.com>,
       Miklos Szeredi <mszeredi@suse.cz>
Subject: [patch 03/32] fuse: fix NULL deref in fuse_file_alloc()
Message-ID: <20090131023932.GD12147@kroah.com>
References: <20090131023411.032399235@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fuse-fix-null-deref-in-fuse_file_alloc.patch"
In-Reply-To: <20090131023906.GA12147@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Carpenter <error27@gmail.com>

commit bb875b38dc5e343bdb696b2eab8233e4d195e208 upstream.

ff is set to NULL and then dereferenced on line 65.  Compile tested only.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/fuse/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -54,7 +54,7 @@ struct fuse_file *fuse_file_alloc(void)
 		ff->reserved_req = fuse_request_alloc();
 		if (!ff->reserved_req) {
 			kfree(ff);
-			ff = NULL;
+			return NULL;
 		} else {
 			INIT_LIST_HEAD(&ff->write_entry);
 			atomic_set(&ff->count, 0);

