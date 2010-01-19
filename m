Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799Ab0ASBN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab0ASBN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 20:13:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029Ab0ASBN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 20:13:57 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:22806 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab0ASBN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 20:13:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=K6mlBZcvPpHxiImJYvnyRXiauTdYjJvUrRhfxwRnOom/JRhOsSs+5RpsDCXBI4zvOD
         PvVZggS+Dn0bPxryiVdjTjevhLKgbu8++1ZkrfKf6MieXfmL+NfGranXQ6xwq7IDfRuQ
         NgyIjJ6TrAnI/L1d8oXHrB5dA9gcjiWZbOwzI=
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Tejun Heo <tj@kernel.org>, Alberto Bertogli <albertito@blitiri.com.ar>,
       Jiri Kosina <jkosina@suse.cz>, linux-fsdevel@vger.kernel.org
Subject: [PATCH] fs/bio.c: fix shadows sparse warning.
Date: Mon, 18 Jan 2010 20:13:21 -0500
Message-Id: <051f23a2b18d46fe0dd732a26e9d4507a19cfca4.1263863246.git.tfransosi@gmail.com>
X-Mailer: git-send-email 1.6.6.201.g56119
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/bio.c:81:33: warning: symbol 'bslab' shadows an earlier one
fs/bio.c:74:25: originally declared here

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 fs/bio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 76e6713..12429c9 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -78,7 +78,7 @@ static struct kmem_cache *bio_find_or_create_slab(unsigned int extra_size)
 
 	i = 0;
 	while (i < bio_slab_nr) {
-		struct bio_slab *bslab = &bio_slabs[i];
+		bslab = &bio_slabs[i];
 
 		if (!bslab->slab && entry == -1)
 			entry = i;
-- 
1.6.6.201.g56119

