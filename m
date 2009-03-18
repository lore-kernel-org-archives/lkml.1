Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbZCRQRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbZCRQRX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 12:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbZCRQQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 12:16:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbZCRQQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 12:16:43 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] BTRFS: Transpose parent_objectid and parent_gen in struct
	btrfs_fid
To: balajirrao@gmail.com, dwmw2@infradead.org, chris.mason@oracle.com
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 18 Mar 2009 16:16:26 +0000
Message-ID: <20090318161626.16521.91662.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Transpose parent_objectid and parent_gen in struct btrfs_fid so that gen and
parent_gen (both u32) are adjacent, thus packing nicely between the u64
members.

This would seem to be reasonable as the parent generation number is always
used if the parent objectid is.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/btrfs/export.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/fs/btrfs/export.h b/fs/btrfs/export.h
index 074348a..319cc6e 100644
--- a/fs/btrfs/export.h
+++ b/fs/btrfs/export.h
@@ -10,8 +10,8 @@ struct btrfs_fid {
 	u64 root_objectid;
 	u32 gen;
 
-	u64 parent_objectid;
 	u32 parent_gen;
+	u64 parent_objectid;
 
 	u64 parent_root_objectid;
 } __attribute__ ((packed));

