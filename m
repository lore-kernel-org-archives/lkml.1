Return-Path: <linux-kernel-owner+w=401wt.eu-S935830AbZAOWk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935830AbZAOWk4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:40:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933995AbZAOWDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:03:51 -0500
Received: from kroah.org ([198.145.64.141]:38961 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932667AbZAOWDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:03:43 -0500
Date: Thu, 15 Jan 2009 14:01:34 -0800
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
       alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 67/85] fix switch_names() breakage in short-to-short case
Message-ID: <20090115220134.GP17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-switch_names-breakage-in-short-to-short-case.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit dc711ca35f9d95a1eec02118e0c298b5e3068315 upstream.

We want ->name.len to match the resulting name on *both*
source and target

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/dcache.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1615,8 +1615,11 @@ static void switch_names(struct dentry *
 			 */
 			memcpy(dentry->d_iname, target->d_name.name,
 					target->d_name.len + 1);
+			dentry->d_name.len = target->d_name.len;
+			return;
 		}
 	}
+	do_switch(dentry->d_name.len, target->d_name.len);
 }
 
 /*
@@ -1676,7 +1679,6 @@ already_unhashed:
 
 	/* Switch the names.. */
 	switch_names(dentry, target);
-	do_switch(dentry->d_name.len, target->d_name.len);
 	do_switch(dentry->d_name.hash, target->d_name.hash);
 
 	/* ... and switch the parents */
@@ -1781,7 +1783,6 @@ static void __d_materialise_dentry(struc
 	struct dentry *dparent, *aparent;
 
 	switch_names(dentry, anon);
-	do_switch(dentry->d_name.len, anon->d_name.len);
 	do_switch(dentry->d_name.hash, anon->d_name.hash);
 
 	dparent = dentry->d_parent;

