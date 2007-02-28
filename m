Return-Path: <linux-kernel-owner+w=401wt.eu-S932601AbXB1XwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601AbXB1XwO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 18:52:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932611AbXB1XwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 18:52:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45072 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932596AbXB1XwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 18:52:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Make XFS workqueues nonfreezable
Date: Thu, 1 Mar 2007 00:54:32 +0100
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Oleg Nesterov <oleg@tv-sign.ru>,
       vatsa@in.ibm.com, Gautham R Shenoy <ego@in.ibm.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>, David Chinner <dgc@sgi.com>,
       Nigel Cunningham <ncunningham@linuxmail.org>
References: <200702272251.28844.rjw@sisk.pl> <200702282339.31234.rjw@sisk.pl> <20070228224443.GC19542@elf.ucw.cz>
In-Reply-To: <20070228224443.GC19542@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703010054.33536.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since freezable workqueues are broken in 2.6.21-rc
(cf. http://marc.theaimsgroup.com/?l=linux-kernel&m=116855740612755,
http://marc.theaimsgroup.com/?l=linux-kernel&m=117261312523921&w=2)
it's better to change the only user of them, which is XFS, to use "normal"
nonfreezable workqueues.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 fs/xfs/linux-2.6/xfs_buf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.21-rc2/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- linux-2.6.21-rc2.orig/fs/xfs/linux-2.6/xfs_buf.c
+++ linux-2.6.21-rc2/fs/xfs/linux-2.6/xfs_buf.c
@@ -1829,11 +1829,11 @@ xfs_buf_init(void)
 	if (!xfs_buf_zone)
 		goto out_free_trace_buf;
 
-	xfslogd_workqueue = create_freezeable_workqueue("xfslogd");
+	xfslogd_workqueue = create_workqueue("xfslogd");
 	if (!xfslogd_workqueue)
 		goto out_free_buf_zone;
 
-	xfsdatad_workqueue = create_freezeable_workqueue("xfsdatad");
+	xfsdatad_workqueue = create_workqueue("xfsdatad");
 	if (!xfsdatad_workqueue)
 		goto out_destroy_xfslogd_workqueue;
 
