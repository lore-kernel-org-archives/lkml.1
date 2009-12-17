Return-Path: <linux-kernel-owner+w=401wt.eu-S936448AbZLQEVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936448AbZLQEVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:21:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935989AbZLQEFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:05:10 -0500
Received: from kroah.org ([198.145.64.141]:55786 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935781AbZLQEFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:05:00 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:55 2009
Message-Id: <20091217035655.840261049@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Julia Lawall <julia@diku.dk>, Alasdair G Kergon <agk@redhat.com>
Subject: [099/151] dm exception store: free tmp_store on persistent flag error
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Julia Lawall <julia@diku.dk>

commit 613978f8711c7fd4d0aa856872375d2abd7c92ff upstream.

Error handling code following a kmalloc should free the allocated data.

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-exception-store.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -216,7 +216,8 @@ int dm_exception_store_create(struct dm_
 		type = get_type("N");
 	else {
 		ti->error = "Persistent flag is not P or N";
-		return -EINVAL;
+		r = -EINVAL;
+		goto bad_type;
 	}
 
 	if (!type) {


