Return-Path: <linux-kernel-owner+w=401wt.eu-S1754369AbXDVSqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369AbXDVSqh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 14:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbXDVSqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 14:46:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57346 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369AbXDVSqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 14:46:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 1/3] swsusp: Fix snapshot_release
Date: Sun, 22 Apr 2007 20:12:26 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>
References: <200704222010.21999.rjw@sisk.pl>
In-Reply-To: <200704222010.21999.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704222012.27316.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Remove the leftover enable_nonboot_cpus() from snapshot_release().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/user.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6.21-rc6-mm1/kernel/power/user.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/kernel/power/user.c	2007-04-22 19:55:59.000000000 +0200
+++ linux-2.6.21-rc6-mm1/kernel/power/user.c	2007-04-22 19:56:52.000000000 +0200
@@ -86,7 +86,6 @@ static int snapshot_release(struct inode
 	if (data->frozen) {
 		mutex_lock(&pm_mutex);
 		thaw_processes();
-		enable_nonboot_cpus();
 		mutex_unlock(&pm_mutex);
 	}
 	atomic_inc(&snapshot_device_available);

