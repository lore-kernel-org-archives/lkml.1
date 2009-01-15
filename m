Return-Path: <linux-kernel-owner+w=401wt.eu-S932848AbZAOUOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848AbZAOUOG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:14:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765968AbZAOUAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:00:49 -0500
Received: from kroah.org ([198.145.64.141]:48937 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765890AbZAOUAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:00:35 -0500
Date: Thu, 15 Jan 2009 11:58:02 -0800
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
Subject: [patch 22/94] minix: fix add links wrong position calculation
Message-ID: <20090115195802.GV14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="minix-fix-add-link-s-wrong-position-calculation.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

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

