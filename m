Return-Path: <linux-kernel-owner+w=401wt.eu-S932272AbZGABQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272AbZGABQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761614AbZGAAfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:35:55 -0400
Received: from kroah.org ([198.145.64.141]:60712 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761596AbZGAAfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:35:44 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:42 2009
Message-Id: <20090701002442.471525145@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:24:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jonathan Brassow <jbrassow@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: [patch 098/108] dm exception store: fix exstore lookup to be case insensitive
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=dm-exception-store-fix-exstore-lookup-to-be-case-insensitive.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jonathan Brassow <jbrassow@redhat.com>

commit f6bd4eb73cdf2a5bf954e497972842f39cabb7e3 upstream.

When snapshots are created using 'p' instead of 'P' as the
exception store type, the device-mapper table loading fails.

This patch makes the code case insensitive as intended and fixes some
regressions reported with device-mapper snapshots.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-exception-store.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -216,7 +216,7 @@ int dm_exception_store_create(struct dm_
 		return -EINVAL;
 	}
 
-	type = get_type(argv[1]);
+	type = get_type(&persistent);
 	if (!type) {
 		ti->error = "Exception store type not recognised";
 		r = -EINVAL;


