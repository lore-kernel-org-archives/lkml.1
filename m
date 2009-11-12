Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbZKLQ5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbZKLQ5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 11:57:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbZKLQ5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 11:57:40 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:33482 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbZKLQ5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 11:57:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=orxFOLuKC9Nia/jkMAa3LqDGuG2cWEHJR3IUPal9IM+NeB86w4Rx81DayG6JWB5sP5
         7CfuqhiPU8BdSv0Z7CLxSzvWqTis+0H/y/njIeOf/5RxlDbufI+yFvRHMCd6R8MRYyDF
         tlZzlWFrfIU8ZrWWgY7jmgyLP0HMfvMQyPzAA=
Message-ID: <4AFC415C.6040305@gmail.com>
Date: Thu, 12 Nov 2009 18:09:48 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] jffs2: Fix error return in jffs2_do_read_inode_internal()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The returned error should stay negative

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 fs/jffs2/readinode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/jffs2/readinode.c b/fs/jffs2/readinode.c
index 1a80301..9c26738 100644
--- a/fs/jffs2/readinode.c
+++ b/fs/jffs2/readinode.c
@@ -1284,7 +1284,7 @@ static int jffs2_do_read_inode_internal(struct jffs2_sb_info *c,
 				f->target = NULL;
 				mutex_unlock(&f->sem);
 				jffs2_do_clear_inode(c, f);
-				return -ret;
+				return ret;
 			}
 
 			f->target[je32_to_cpu(latest_node->csize)] = '\0';
