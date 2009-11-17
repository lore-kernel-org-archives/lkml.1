Return-Path: <linux-kernel-owner+w=401wt.eu-S1755764AbZKQHXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbZKQHXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 02:23:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755341AbZKQHXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 02:23:45 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57527 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651AbZKQHXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 02:23:44 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/7] xfs: Don't use PF_MEMALLOC
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       xfs-masters@oss.sgi.com, xfs@oss.sgi.com
In-Reply-To: <20091117161551.3DD4.A69D9226@jp.fujitsu.com>
References: <20091117161551.3DD4.A69D9226@jp.fujitsu.com>
Message-Id: <20091117162235.3DEB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 17 Nov 2009 16:23:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Non MM subsystem must not use PF_MEMALLOC. Memory reclaim need few
memory, anyone must not prevent it. Otherwise the system cause
mysterious hang-up and/or OOM Killer invokation.

Cc: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org
Cc: xfs-masters@oss.sgi.com
Cc: xfs@oss.sgi.com
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 965df12..b9a06fc 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1724,8 +1724,6 @@ xfsbufd(
 	int		count;
 	xfs_buf_t	*bp;
 
-	current->flags |= PF_MEMALLOC;
-
 	set_freezable();
 
 	do {
-- 
1.6.2.5



