Return-Path: <linux-kernel-owner+w=401wt.eu-S1760140AbZKFWWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760140AbZKFWWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:22:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932381AbZKFWWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:22:41 -0500
Received: from kroah.org ([198.145.64.141]:56760 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932330AbZKFWWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:39 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:42 2009
Message-Id: <20091106221541.949266293@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mikulas Patocka <mpatocka@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [25/99] dm snapshot: require non zero chunk size by end of ctr
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=dm-snapshot-require-non-zero-chunk-size-by-end-of-ctr.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mikulas Patocka <mpatocka@redhat.com>

commit 3f2412dc85260e5aae7ebb03bf50d5b1407e3083 upstream.

If we are creating snapshot with memory-stored exception store, fail if
the user didn't specify chunk size. Zero chunk size would probably crash
a lot of places in the rest of snapshot code.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Jonathan Brassow <jbrassow@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-snap.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -673,6 +673,11 @@ static int snapshot_ctr(struct dm_target
 	bio_list_init(&s->queued_bios);
 	INIT_WORK(&s->queued_bios_work, flush_queued_bios);
 
+	if (!s->store->chunk_size) {
+		ti->error = "Chunk size not set";
+		goto bad_load_and_register;
+	}
+
 	/* Add snapshot to the list of snapshots for this origin */
 	/* Exceptions aren't triggered till snapshot_resume() is called */
 	if (register_snapshot(s)) {


