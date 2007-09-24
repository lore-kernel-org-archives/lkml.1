Return-Path: <linux-kernel-owner+w=401wt.eu-S1761611AbXIXQcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761611AbXIXQcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760297AbXIXQ0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:26:08 -0400
Received: from canuck.infradead.org ([209.217.80.40]:47410 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760609AbXIXQ0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:26:06 -0400
Date: Mon, 24 Sep 2007 09:21:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, dhowells@redhat.com, agruen@suse.de
Subject: [21/50] afs: mntput called before dput
Message-ID: <20070924162107.GV13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="afs-mntput-called-before-dput.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@suse.de>

commit 1a1a1a758bf0107d1f78ff1d622f45987803d894 in mainline.

dput must be called before mntput here.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Acked-By: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/afs/mntpt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/afs/mntpt.c
+++ b/fs/afs/mntpt.c
@@ -235,8 +235,8 @@ static void *afs_mntpt_follow_link(struc
 	err = do_add_mount(newmnt, nd, MNT_SHRINKABLE, &afs_vfsmounts);
 	switch (err) {
 	case 0:
-		mntput(nd->mnt);
 		dput(nd->dentry);
+		mntput(nd->mnt);
 		nd->mnt = newmnt;
 		nd->dentry = dget(newmnt->mnt_root);
 		schedule_delayed_work(&afs_mntpt_expiry_timer,

-- 
