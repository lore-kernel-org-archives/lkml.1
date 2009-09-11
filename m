Return-Path: <linux-kernel-owner+w=401wt.eu-S1753480AbZIKA3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbZIKA3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 20:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbZIKA3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 20:29:18 -0400
Received: from kroah.org ([198.145.64.141]:38126 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341AbZIKA3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 20:29:15 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Sep 10 17:24:12 2009
Message-Id: <20090911002412.247250943@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Sep 2009 17:23:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mikulas Patocka <mpatocka@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [patch 21/22] dm exception store: split set_chunk_size
References: <20090911002246.666327880@mini.kroah.org>
Content-Disposition: inline; filename=dm-exception-store-split-set_chunk_size.patch
In-Reply-To: <20090911002616.GA12087@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mikulas Patocka <mpatocka@redhat.com>

commit 2defcc3fb4661e7351cb2ac48d843efc4c64db13 upstream.

Break the function set_chunk_size to two functions in preparation for
the fix in the following patch.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-exception-store.c |    8 ++++++++
 drivers/md/dm-exception-store.h |    4 ++++
 2 files changed, 12 insertions(+)

--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -171,6 +171,14 @@ static int set_chunk_size(struct dm_exce
 	 */
 	chunk_size_ulong = round_up(chunk_size_ulong, PAGE_SIZE >> 9);
 
+	return dm_exception_store_set_chunk_size(store, chunk_size_ulong,
+						 error);
+}
+
+int dm_exception_store_set_chunk_size(struct dm_exception_store *store,
+				      unsigned long chunk_size_ulong,
+				      char **error)
+{
 	/* Check chunk_size is a power of 2 */
 	if (!is_power_of_2(chunk_size_ulong)) {
 		*error = "Chunk size is not a power of 2";
--- a/drivers/md/dm-exception-store.h
+++ b/drivers/md/dm-exception-store.h
@@ -168,6 +168,10 @@ static inline chunk_t sector_to_chunk(st
 int dm_exception_store_type_register(struct dm_exception_store_type *type);
 int dm_exception_store_type_unregister(struct dm_exception_store_type *type);
 
+int dm_exception_store_set_chunk_size(struct dm_exception_store *store,
+				      unsigned long chunk_size_ulong,
+				      char **error);
+
 int dm_exception_store_create(struct dm_target *ti, int argc, char **argv,
 			      unsigned *args_used,
 			      struct dm_exception_store **store);


