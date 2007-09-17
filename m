Return-Path: <linux-kernel-owner+w=401wt.eu-S1760700AbXIQV46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760700AbXIQV46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 17:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758230AbXIQV4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 17:56:45 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:58614 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933061AbXIQV4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 17:56:43 -0400
Date: Mon, 17 Sep 2007 16:52:04 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       ecryptfs-devel@lists.sourceforge.net
Subject: [PATCH 11/11] eCryptfs: Replace magic numbers
Message-ID: <20070917215204.GS13679@halcrow.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20070917214436.GH13679@halcrow.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070917214436.GH13679@halcrow.austin.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replace some magic numbers with sizeof() equivalents.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/crypto.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 3b3cf27..425a144 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1426,10 +1426,10 @@ static int parse_header_metadata(struct ecryptfs_crypt_stat *crypt_stat,
 	u32 header_extent_size;
 	u16 num_header_extents_at_front;
 
-	memcpy(&header_extent_size, virt, 4);
+	memcpy(&header_extent_size, virt, sizeof(u32));
 	header_extent_size = be32_to_cpu(header_extent_size);
-	virt += 4;
-	memcpy(&num_header_extents_at_front, virt, 2);
+	virt += sizeof(u32);
+	memcpy(&num_header_extents_at_front, virt, sizeof(u16));
 	num_header_extents_at_front = be16_to_cpu(num_header_extents_at_front);
 	crypt_stat->num_header_extents_at_front =
 		(int)num_header_extents_at_front;
-- 
1.5.1.6

