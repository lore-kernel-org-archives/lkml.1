Return-Path: <linux-kernel-owner+w=401wt.eu-S1760166AbZAaDAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760166AbZAaDAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:00:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756291AbZAaCrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:21 -0500
Received: from kroah.org ([198.145.64.141]:55195 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756378AbZAaCrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:47:12 -0500
Date: Fri, 30 Jan 2009 18:42:25 -0800
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
Subject: [patch 06/43] fuse: fix NULL deref in fuse_file_alloc()
Message-ID: <20090131024225.GG12368@kroah.com>
References: <20090131022548.656772939@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fuse-fix-null-deref-in-fuse_file_alloc.patch"
In-Reply-To: <20090131024158.GA12368@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

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

