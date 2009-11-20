Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbZKTVyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbZKTVyv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 16:54:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755747AbZKTVyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 16:54:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755643AbZKTVys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 16:54:48 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/3] SLOW_WORK: Fix GFS2 to #include <linux/module.h> before
	using THIS_MODULE
To: wilhelm.meier@fh-kl.de, linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, steved@redhat.com
Date: Fri, 20 Nov 2009 21:54:47 +0000
Message-ID: <20091120215447.15448.97571.stgit@warthog.procyon.org.uk>
In-Reply-To: <20091120215437.15448.26909.stgit@warthog.procyon.org.uk>
References: <20091120215437.15448.26909.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GFS2 has been altered to pass THIS_MODULE to slow_work_register_user(), but
hasn't been altered to #include <linux/module.h> to provide it, resulting in
the following error:

	fs/gfs2/recovery.c:596: error: 'THIS_MODULE' undeclared here (not in a function)

Add the missing #include.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/gfs2/recovery.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index b2bb779..09fa319 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -7,6 +7,7 @@
  * of the GNU General Public License version 2.
  */
 
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/completion.h>

