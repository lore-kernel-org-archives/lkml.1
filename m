Return-Path: <linux-kernel-owner+w=401wt.eu-S1755598AbYE1WHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbYE1WHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 18:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753503AbYE1WGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 18:06:49 -0400
Received: from styx.suse.cz ([82.119.242.94]:54753 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753246AbYE1WGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 18:06:48 -0400
Date: Thu, 29 May 2008 00:06:46 +0200
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Silence warnings about non-uptodate buffers
Message-ID: <20080528220646.GB16018@duck.suse.cz>
References: <12120117733479-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12120117733479-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 28-05-08 23:56:08, Jan Kara wrote:
> Hello,
> 
> the series of patches below gets rid of warning messages in mark_buffer_dirty()
> when underlying block device becomes unavailable. Andrew, would you merge them
> please?
> 
  And just for reference a similar patch for UDF which I'll merge through
my git tree.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

>From 756bc361a065b65df9977c2632472f587659a6f7 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 28 May 2008 23:39:19 +0200
Subject: [PATCH] udf: Silence warnings about non-uptodate buffers

When underlying block device becomes unavailable (e.g. someone pulling an
USB stick from under us), kernel produces warning about non-uptodate buffer
(superblock) being marked dirty. Silence these warnings by making buffer
uptodate before marking it dirty.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 7a5f69b..dd295b8 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1770,6 +1770,7 @@ static void udf_open_lvid(struct super_block *sb)
 			le16_to_cpu(lvid->descTag.descCRCLength)));
 
 	lvid->descTag.tagChecksum = udf_tag_checksum(&lvid->descTag);
+	set_buffer_uptodate(bh);
 	mark_buffer_dirty(bh);
 }
 
@@ -1805,6 +1806,7 @@ static void udf_close_lvid(struct super_block *sb)
 				le16_to_cpu(lvid->descTag.descCRCLength)));
 
 	lvid->descTag.tagChecksum = udf_tag_checksum(&lvid->descTag);
+	set_buffer_uptodate(bh);
 	mark_buffer_dirty(bh);
 }
 
-- 
1.5.2.4

