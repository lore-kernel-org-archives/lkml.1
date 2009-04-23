Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500AbZDWPnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbZDWPnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 11:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750860AbZDWPn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 11:43:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33965 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbZDWPn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 11:43:28 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] ROMFS: Advance destination buffer pointer when reading
	from a blockdev
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, monstr@monstr.eu, linux-kernel@vger.kernel.org
Date: Thu, 23 Apr 2009 16:41:18 +0100
Message-ID: <20090423154118.20265.68122.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090423154113.20265.38838.stgit@warthog.procyon.org.uk>
References: <20090423154113.20265.38838.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RomFS should advance the destination buffer pointer when reading data from a
blockdev source (the data may be split over multiple blocks, each requiring its
own sb_read() call).  Without this, all the data is copied to the beginning of
the output buffer.

Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Michal Simek <monstr@monstr.eu>
---

 fs/romfs/storage.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/fs/romfs/storage.c b/fs/romfs/storage.c
index 66ce9dd..b3208ad 100644
--- a/fs/romfs/storage.c
+++ b/fs/romfs/storage.c
@@ -120,6 +120,7 @@ static int romfs_blk_read(struct super_block *sb, unsigned long pos,
 			return -EIO;
 		memcpy(buf, bh->b_data + offset, segment);
 		brelse(bh);
+		buf += segment;
 		buflen -= segment;
 		pos += segment;
 	}

