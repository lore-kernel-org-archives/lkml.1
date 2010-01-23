Return-Path: <linux-kernel-owner+w=401wt.eu-S1755628Ab0AWATP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab0AWATP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:19:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450Ab0AWATE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:19:04 -0500
Received: from kroah.org ([198.145.64.141]:35080 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755100Ab0AWAS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:18:56 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jan 22 16:11:12 2010
Message-Id: <20100123001112.646965152@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 22 Jan 2010 16:10:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       James Bottomley <James.Bottomley@suse.de>
Subject: [19/29] SCSI: enclosure: fix oops while iterating enclosure_status array
In-Reply-To: <20100123001145.GA7391@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: James Bottomley <James.Bottomley@suse.de>

commit cc9b2e9f6603190c009e5d2629ce8e3f99571346 upstream.

Based on patch originally by Jeff Mahoney <jeffm@suse.com>

 enclosure_status is expected to be a NULL terminated array of strings
 but isn't actually NULL terminated. When writing an invalid value to
 /sys/class/enclosure/.../.../status, it goes off the end of the array
 and Oopses.


Fix by making the assumption true and adding NULL at the end.

Reported-by: Artur Wojcik <artur.wojcik@intel.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/enclosure.c  |    1 +
 include/linux/enclosure.h |    2 ++
 2 files changed, 3 insertions(+)

--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -391,6 +391,7 @@ static const char *const enclosure_statu
 	[ENCLOSURE_STATUS_NOT_INSTALLED] = "not installed",
 	[ENCLOSURE_STATUS_UNKNOWN] = "unknown",
 	[ENCLOSURE_STATUS_UNAVAILABLE] = "unavailable",
+	[ENCLOSURE_STATUS_MAX] = NULL,
 };
 
 static const char *const enclosure_type [] = {
--- a/include/linux/enclosure.h
+++ b/include/linux/enclosure.h
@@ -42,6 +42,8 @@ enum enclosure_status {
 	ENCLOSURE_STATUS_NOT_INSTALLED,
 	ENCLOSURE_STATUS_UNKNOWN,
 	ENCLOSURE_STATUS_UNAVAILABLE,
+	/* last element for counting purposes */
+	ENCLOSURE_STATUS_MAX
 };
 
 /* SFF-8485 activity light settings */


