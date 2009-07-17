Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958AbZGQUTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbZGQUTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 16:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755255AbZGQUTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 16:19:53 -0400
Received: from kroah.org ([198.145.64.141]:43124 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754963AbZGQUTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:19:52 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jul 17 13:12:35 2009
Message-Id: <20090717201235.020571302@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 17 Jul 2009 13:09:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       NeilBrown <neilb@suse.de>
Subject: [patch 17/24] md: avoid dereferencing NULL pointer when accessing suspend_* sysfs attributes.
References: <20090717200851.907421303@mini.kroah.org>
Content-Disposition: inline; filename=md-avoid-dereferencing-null-pointer-when-accessing-suspend_-sysfs-attributes.patch
In-Reply-To: <20090717201639.GA14209@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit b8d966efd9a46a9a35beac50cbff6e30565125ef upstream.

If we try to modify one of the md/ sysfs files
  suspend_lo or suspend_hi
when the array is not active, we dereference a NULL.
Protect against that.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/md.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3589,7 +3589,8 @@ suspend_lo_store(mddev_t *mddev, const c
 	char *e;
 	unsigned long long new = simple_strtoull(buf, &e, 10);
 
-	if (mddev->pers->quiesce == NULL)
+	if (mddev->pers == NULL ||
+	    mddev->pers->quiesce == NULL)
 		return -EINVAL;
 	if (buf == e || (*e && *e != '\n'))
 		return -EINVAL;
@@ -3617,7 +3618,8 @@ suspend_hi_store(mddev_t *mddev, const c
 	char *e;
 	unsigned long long new = simple_strtoull(buf, &e, 10);
 
-	if (mddev->pers->quiesce == NULL)
+	if (mddev->pers == NULL ||
+	    mddev->pers->quiesce == NULL)
 		return -EINVAL;
 	if (buf == e || (*e && *e != '\n'))
 		return -EINVAL;


