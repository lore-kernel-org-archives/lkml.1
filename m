Return-Path: <linux-kernel-owner+w=401wt.eu-S932371AbZKFWWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371AbZKFWWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:22:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932330AbZKFWWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:22:37 -0500
Received: from kroah.org ([198.145.64.141]:56719 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932250AbZKFWWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:33 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:41 2009
Message-Id: <20091106221541.057271576@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jonathan Brassow <jbrassow@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [18/99] dm snapshot: free exception store on init failure
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=dm-snapshot-free-exception-store-on-init-failure.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jonathan Brassow <jbrassow@redhat.com>

commit 034a186d29dbcef099e57ab23ec39440596be911 upstream.

While initializing the snapshot module, if we fail to register
the snapshot target then we must back-out the exception store
module initialization.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-snap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1465,7 +1465,7 @@ static int __init dm_snapshot_init(void)
 	r = dm_register_target(&snapshot_target);
 	if (r) {
 		DMERR("snapshot target register failed %d", r);
-		return r;
+		goto bad_register_snapshot_target;
 	}
 
 	r = dm_register_target(&origin_target);
@@ -1522,6 +1522,9 @@ bad2:
 	dm_unregister_target(&origin_target);
 bad1:
 	dm_unregister_target(&snapshot_target);
+
+bad_register_snapshot_target:
+	dm_exception_store_exit();
 	return r;
 }
 


