Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbYJ3K4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbYJ3K4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 06:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbYJ3K4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 06:56:41 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:47694 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbYJ3K4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 06:56:40 -0400
Date: Thu, 30 Oct 2008 12:56:37 +0200 (EET)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: Alasdair Kergon <agk@redhat.com>
cc: Heinz Mauelshagen <hjm@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] dm raid1: add missing braces
Message-ID: <Pine.LNX.4.64.0810301254290.7072@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696208474-2003021218-1225364197=:7072"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696208474-2003021218-1225364197=:7072
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT


Commit 1f965b1943 (dm raid1: separate region_hash interface
part1) broke it.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Cc: Heinz Mauelshagen <hjm@redhat.com>
---
 drivers/md/dm-raid1.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 92dcc06..9d7b53e 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -656,9 +656,10 @@ static void do_failures(struct mirror_set *ms, struct bio_list *failures)
 		return;
 
 	if (!ms->log_failure) {
-		while ((bio = bio_list_pop(failures)))
+		while ((bio = bio_list_pop(failures))) {
 			ms->in_sync = 0;
 			dm_rh_mark_nosync(ms->rh, bio, bio->bi_size, 0);
+		}
 		return;
 	}
 
-- 
1.5.2.2

---696208474-2003021218-1225364197=:7072--
