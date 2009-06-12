Return-Path: <linux-kernel-owner+w=401wt.eu-S1760219AbZFLM42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760219AbZFLM42 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757146AbZFLMy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:54:26 -0400
Received: from brick.kernel.dk ([93.163.65.50]:52289 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756244AbZFLMyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:54:19 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr, dedekind1@gmail.com,
       fweisbec@gmail.com, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 03/15] ubifs: register backing_dev_info
Date: Fri, 12 Jun 2009 14:54:03 +0200
Message-Id: <1244811255-5391-4-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1244811255-5391-1-git-send-email-jens.axboe@oracle.com>
References: <1244811255-5391-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/ubifs/super.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 3589eab..3260b73 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1937,6 +1937,9 @@ static int ubifs_fill_super(struct super_block *sb, void *data, int silent)
 	err  = bdi_init(&c->bdi);
 	if (err)
 		goto out_close;
+	err = bdi_register(&c->bdi, NULL, "ubifs");
+	if (err)
+		goto out_bdi;
 
 	err = ubifs_parse_options(c, data, 0);
 	if (err)
-- 
1.6.3.rc0.1.gf800

