Return-Path: <linux-kernel-owner+w=401wt.eu-S1764045AbYDNWwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764045AbYDNWwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 18:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762297AbYDNWsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 18:48:16 -0400
Received: from rv-out-0708.google.com ([209.85.198.240]:1379 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762142AbYDNWsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 18:48:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tsxkc1M+pzmsziFyKjH0nTjHwKXcY1xjjvu5ogl1aV94AfXMW9xQvNxhj2weLW3mh5xhut1S7L702lEVX76q8FOAVyZujnLN6YkQvxYE01KkXniIqpaGdLgiZMMCsxxFnj43GZf0r1+oOecOHbx48yw099sxYs5EwtgCqGJB9kk=
Subject: [PATCH-mm 13/15] hfsplus: Use get/put_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 15:48:02 -0700
Message-Id: <1208213282.11920.43.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/hfsplus/wrapper.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/hfsplus/wrapper.c b/fs/hfsplus/wrapper.c
index 72cab78..175d08e 100644
--- a/fs/hfsplus/wrapper.c
+++ b/fs/hfsplus/wrapper.c
@@ -47,7 +47,7 @@ static int hfsplus_read_mdb(void *bufptr, struct hfsplus_wd *wd)
 		return 0;
 	wd->ablk_start = be16_to_cpu(*(__be16 *)(bufptr + HFSP_WRAPOFF_ABLKSTART));
 
-	extent = be32_to_cpu(get_unaligned((__be32 *)(bufptr + HFSP_WRAPOFF_EMBEDEXT)));
+	extent = get_unaligned_be32(bufptr + HFSP_WRAPOFF_EMBEDEXT);
 	wd->embed_start = (extent >> 16) & 0xFFFF;
 	wd->embed_count = extent & 0xFFFF;
 
-- 
1.5.5.144.g3e42


