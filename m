Return-Path: <linux-kernel-owner+w=401wt.eu-S1756016AbZG1XHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016AbZG1XHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755911AbZG1XEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:04:01 -0400
Received: from kroah.org ([198.145.64.141]:42979 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755590AbZG1XD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:03:58 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 15:59:43 2009
Message-Id: <20090728225943.431729356@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 15:58:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       NeilBrown <neilb@suse.de>
Subject: [patch 17/37] md: avoid dereferencing NULL pointer when accessing suspend_* sysfs attributes.
References: <20090728225828.431071451@mini.kroah.org>
Content-Disposition: inline; filename=md-avoid-dereferencing-null-pointer-when-accessing-suspend_-sysfs-attributes.patch
In-Reply-To: <20090728230145.GA10486@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

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
@@ -3281,7 +3281,8 @@ suspend_lo_store(mddev_t *mddev, const c
 	char *e;
 	unsigned long long new = simple_strtoull(buf, &e, 10);
 
-	if (mddev->pers->quiesce == NULL)
+	if (mddev->pers == NULL ||
+	    mddev->pers->quiesce == NULL)
 		return -EINVAL;
 	if (buf == e || (*e && *e != '\n'))
 		return -EINVAL;
@@ -3309,7 +3310,8 @@ suspend_hi_store(mddev_t *mddev, const c
 	char *e;
 	unsigned long long new = simple_strtoull(buf, &e, 10);
 
-	if (mddev->pers->quiesce == NULL)
+	if (mddev->pers == NULL ||
+	    mddev->pers->quiesce == NULL)
 		return -EINVAL;
 	if (buf == e || (*e && *e != '\n'))
 		return -EINVAL;


