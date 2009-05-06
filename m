Return-Path: <linux-kernel-owner+w=401wt.eu-S1761647AbZEFWJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761647AbZEFWJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761539AbZEFVyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:54:55 -0400
Received: from kroah.org ([198.145.64.141]:57249 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761491AbZEFVyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:54:50 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:48:00 2009
Message-Id: <20090506214800.297187308@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:46:04 -0700
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
       alan@lxorguk.ukuu.org.uk, David Howells <dhowells@redhat.com>,
       Hugh Dickins <hugh@veritas.com>
Subject: [patch 36/58] Annotate struct fs_structs usage count restriction
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=annotate-struct-fs_struct-s-usage-count-restriction.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Howells <dhowells@redhat.com>

commit 795e2fe0a3b69dbc040d7efcf517e0cbad6901d0 upstream.

Annotate struct fs_struct's usage count to indicate the restrictions upon it.
It may not be incremented, except by clone(CLONE_FS), as this affects the
check in check_unsafe_exec() in fs/exec.c.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: stable@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/fs_struct.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/fs_struct.h
+++ b/include/linux/fs_struct.h
@@ -4,7 +4,10 @@
 #include <linux/path.h>
 
 struct fs_struct {
-	atomic_t count;
+	atomic_t count;	/* This usage count is used by check_unsafe_exec() for
+			 * security checking purposes - therefore it may not be
+			 * incremented, except by clone(CLONE_FS).
+			 */
 	rwlock_t lock;
 	int umask;
 	struct path root, pwd;


