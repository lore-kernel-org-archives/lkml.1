Return-Path: <linux-kernel-owner+w=401wt.eu-S1758295AbYBSUPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295AbYBSUPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 15:15:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbYBSUPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 15:15:04 -0500
Received: from mail.gmx.net ([213.165.64.20]:33530 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750792AbYBSUPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 15:15:01 -0500
X-Authenticated: #36809985
X-Provags-ID: V01U2FsdGVkX19Jx0R9vn1JE/g0w/1y/rqwQz1/OzTmoon6l0YKi0
	OpBG9Wjs4DW8OT
Subject: [PATCH] splice: fix problem with sys_tee and SPLICE_F_NONBLOCK
From: Johann Felix Soden <johfel@gmx.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Patrick McManus <mcmanus@ducksong.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 19 Feb 2008 21:14:51 +0100
Message-Id: <1203452091.7758.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johann Felix Soden <johfel@users.sourceforge.net>

With SPLICE_F_NONBLOCK sys_tee should return number of duplicated bytes,
not only -EAGAIN on success.

This patch also solves the problem, which is described on
http://article.gmane.org/gmane.linux.kernel/642502.

Signed-off-by: Johann Felix Soden <johfel@users.sourceforge.net>
---
 fs/splice.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 9b559ee..184fd66 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1711,7 +1711,7 @@ static long do_tee(struct file *in, struct file *out, size_t len,
 			ret = link_opipe_prep(opipe, flags);
 			if (!ret) {
 				ret = link_pipe(ipipe, opipe, len, flags);
-				if (!ret && (flags & SPLICE_F_NONBLOCK))
+				if (ret < 0 && (flags & SPLICE_F_NONBLOCK))
 					ret = -EAGAIN;
 			}
 		}
-- 
1.5.4.2


