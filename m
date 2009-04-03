Return-Path: <linux-kernel-owner+w=401wt.eu-S1762457AbZDCBe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762457AbZDCBe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 21:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755500AbZDCBer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 21:34:47 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:50769 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbZDCBeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 21:34:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=SerVdo6L1Sxxbl0HRMvIIX9f+zEOesBljrN+unJPDl1efu8b3Z/9o0vWC46XPNee4L
         W9ugCAxLX2+c7cFkudAe8CV1Rex12bi/v2wox1KmXH/PLekaQWmsOVu5zmrp8xTOh+or
         UXfG4efUlj683Mv7cxTECxjoUM9ltmoknQ7Yc=
Date: Fri, 3 Apr 2009 05:34:37 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Jeff Mahoney <jeffm@suse.com>, reiserfs-devel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] reiserfs: fix printk format warning
Message-ID: <20090403013437.GA29003@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warning message
fs/reiserfs/procfs.c:393: warning: format '%u' expects type 'unsigned int', but argument 22 has type 'long unsigned int'
introduced in 600ed4167
(reiserfs: audit transaction ids to always be unsigned ints)

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 include/linux/reiserfs_fs_sb.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/reiserfs_fs_sb.h b/include/linux/reiserfs_fs_sb.h
index 5621d87..1d1594a 100644
--- a/include/linux/reiserfs_fs_sb.h
+++ b/include/linux/reiserfs_fs_sb.h
@@ -193,7 +193,7 @@ struct reiserfs_journal {
 	atomic_t j_wcount;	/* count of writers for current commit */
 	unsigned long j_bcount;	/* batch count. allows turning X transactions into 1 */
 	unsigned long j_first_unflushed_offset;	/* first unflushed transactions offset */
-	unsigned long j_last_flush_trans_id;	/* last fully flushed journal timestamp */
+	unsigned int j_last_flush_trans_id;	/* last fully flushed journal timestamp */
 	struct buffer_head *j_header_bh;
 
 	time_t j_trans_start_time;	/* time this transaction started */
