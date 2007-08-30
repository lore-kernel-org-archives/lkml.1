Return-Path: <linux-kernel-owner+w=401wt.eu-S1761417AbXH3QVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761417AbXH3QVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 12:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755061AbXH3QVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 12:21:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757776AbXH3QVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 12:21:36 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] MTD: Initialise s_flags in get_sb_mtd_aux()
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       dhowells@redhat.com
Date: Thu, 30 Aug 2007 17:21:19 +0100
Message-ID: <20070830162119.28355.70078.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Initialise s_flags in get_sb_mtd_aux() from the flags parameter.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/mtd/mtdsuper.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/mtdsuper.c b/drivers/mtd/mtdsuper.c
index aca3319..9b430f2 100644
--- a/drivers/mtd/mtdsuper.c
+++ b/drivers/mtd/mtdsuper.c
@@ -70,6 +70,8 @@ static int get_sb_mtd_aux(struct file_system_type *fs_type, int flags,
 	DEBUG(1, "MTDSB: New superblock for device %d (\"%s\")\n",
 	      mtd->index, mtd->name);
 
+	sb->s_flags = flags;
+
 	ret = fill_super(sb, data, flags & MS_SILENT ? 1 : 0);
 	if (ret < 0) {
 		up_write(&sb->s_umount);

