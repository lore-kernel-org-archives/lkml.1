Return-Path: <linux-kernel-owner+w=401wt.eu-S1757800AbYCaU3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757800AbYCaU3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 16:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757426AbYCaU3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 16:29:05 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:47888 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757419AbYCaU3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 16:29:04 -0400
Date: Mon, 31 Mar 2008 14:29:01 -0600
From: Alex Chiang <achiang@hp.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       btrfs-devel@oss.oracle.com
Subject: [PATCH 2/2] btrfs-progs: Stop stomping on 'name' input parameter
Message-ID: <20080331202901.GC341@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, btrfs-devel@oss.oracle.com
References: <200802211609.50563.chris.mason@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802211609.50563.chris.mason@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In btrfs_name_hash, Local variable 'buf' is declared as

	__u32 buf[2];

but we then try to do this:

	buf[0] = 0x67452301;
	buf[1] = 0xefcdab89;
	buf[2] = 0x98badcfe;
	buf[3] = 0x10325476;

Oops. Fix buf to be the proper size.

Signed-off-by: Alex Chiang <achiang@hp.com>
---
 hash.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/hash.c b/hash.c
index 58f0be6..6a0795d 100644
--- a/hash.c
+++ b/hash.c
@@ -80,7 +80,7 @@ u64 btrfs_name_hash(const char *name, int len)
 	__u32	hash;
 	__u32	minor_hash = 0;
 	const char	*p;
-	__u32		in[8], buf[2];
+	__u32		in[8], buf[4];
 	u64		hash_result;
 
 	/* Initialize the default seed for the hash checksum functions */
-- 
1.5.3.1.g1e61

