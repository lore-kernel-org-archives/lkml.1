Return-Path: <linux-kernel-owner+w=401wt.eu-S1758031AbYKQHap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031AbYKQHap (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:30:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbYKQHV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:21:26 -0500
Received: from kroah.org ([198.145.64.141]:38477 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754669AbYKQHVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:21:15 -0500
Date: Sun, 16 Nov 2008 23:15:47 -0800
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
       alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 24/46] Fix broken ownership of /proc/sys/ files
Message-ID: <20081117071547.GY29522@kroah.com>
References: <20081117070621.430169021@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-broken-ownership-of-proc-sys-files.patch"
In-Reply-To: <20081117071333.GA29522@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Al Viro <viro@ZenIV.linux.org.uk>

commit 5c06fe772da43db63b053addcd2c267f76d0be91 upstream.

D'oh...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Reported-and-tested-by: Peter Palfrader <peter@palfrader.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/proc_sysctl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -31,6 +31,7 @@ static struct inode *proc_sys_make_inode
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
 	inode->i_flags |= S_PRIVATE; /* tell selinux to ignore this inode */
 	inode->i_mode = table->mode;
+	inode->i_uid = inode->i_gid = 0;
 	if (!table->child) {
 		inode->i_mode |= S_IFREG;
 		inode->i_op = &proc_sys_inode_operations;

-- 
