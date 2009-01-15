Return-Path: <linux-kernel-owner+w=401wt.eu-S934199AbZAOWIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934199AbZAOWIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933538AbZAOWCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:02:04 -0500
Received: from kroah.org ([198.145.64.141]:38135 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932947AbZAOWB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:01:58 -0500
Date: Thu, 15 Jan 2009 13:59:13 -0800
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
       alan@lxorguk.ukuu.org.uk, Evgeniy Dushistov <dushistov@mail.ru>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: [patch 10/85] minix: fix add links wrong position calculation
Message-ID: <20090115215913.GK17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="minix-fix-add-link-s-wrong-position-calculation.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Evgeniy Dushistov <dushistov@mail.ru>

commit d6b54841f4ddd836c886d1e6ac381cf309ee98a3 upstream.

Fix the add link method.  The oosition in the directory was calculated in
wrong way - it had the incorrect shift direction.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/minix/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/minix/dir.c
+++ b/fs/minix/dir.c
@@ -280,7 +280,7 @@ int minix_add_link(struct dentry *dentry
 	return -EINVAL;
 
 got_it:
-	pos = (page->index >> PAGE_CACHE_SHIFT) + p - (char*)page_address(page);
+	pos = page_offset(page) + p - (char *)page_address(page);
 	err = __minix_write_begin(NULL, page->mapping, pos, sbi->s_dirsize,
 					AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
 	if (err)

