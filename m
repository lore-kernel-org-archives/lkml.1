Return-Path: <linux-kernel-owner+w=401wt.eu-S1759554AbXHVJA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759554AbXHVJA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758515AbXHVIxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:53:18 -0400
Received: from 1wt.eu ([62.212.114.60]:2034 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758387AbXHVIxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:53:16 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822084023.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:16 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 32/58] fs: 9p/conv.c error path fix
Content-Disposition: inline; filename=0032-fs-9p-conv.c-error-path-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When buf_check_overflow() returns != 0 we will hit kfree(ERR_PTR(err))
and it will not be happy about it.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/9p/conv.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/9p/conv.c b/fs/9p/conv.c
index a3ed571..923d75c 100644
--- a/fs/9p/conv.c
+++ b/fs/9p/conv.c
@@ -742,6 +742,7 @@ struct v9fs_fcall *v9fs_create_twrite(u32 fid, u64 offset, u32 count,
 	if (err) {
 		kfree(fc);
 		fc = ERR_PTR(err);
+		goto error;
 	}
 
 	if (buf_check_overflow(bufp)) {
-- 
1.5.2.5

-- 
