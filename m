Return-Path: <linux-kernel-owner+w=401wt.eu-S932687AbZKFWlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687AbZKFWlF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:41:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932389AbZKFWlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:41:00 -0500
Received: from kroah.org ([198.145.64.141]:56749 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339AbZKFWWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:37 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:41 2009
Message-Id: <20091106221541.685797967@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mikulas Patocka <mpatocka@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [23/99] dm exception store: fix failed set_chunk_size error path
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=dm-exception-store-fix-failed-set_chunk_size-error-path.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mikulas Patocka <mpatocka@redhat.com>

commit 0e8c4e4e3ebb15756ddc4170a88149a2cd323cfe upstream.

Properly close the device if failing because of an invalid chunk size.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-exception-store.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -251,7 +251,7 @@ int dm_exception_store_create(struct dm_
 
 	r = set_chunk_size(tmp_store, argv[2], &ti->error);
 	if (r)
-		goto bad_cow;
+		goto bad_ctr;
 
 	r = type->ctr(tmp_store, 0, NULL);
 	if (r) {


