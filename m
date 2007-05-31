Return-Path: <linux-kernel-owner+w=401wt.eu-S1759553AbXEaDdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759553AbXEaDdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 23:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbXEaDcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 23:32:54 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:31895 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053AbXEaDcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 23:32:53 -0400
X-IronPort-AV: i="4.14,596,1170651600"; 
   d="scan'208"; a="31298322:sNHT142731078987"
Subject: [PATCH] [RAMFS NOMMU]: a bug in ramfs_nommu_resize function,
	passing old size to vmtruncate
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Thu, 31 May 2007 11:31:55 +0800
Message-Id: <1180582315.10836.2.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It should be pass "newsize" to vmtruncate function to modify the
inode->i_size,
while the old size is passed to vmtruncate.

This bug was catched by LTP truncate test case on Blackfin platform.
After it was fixed, the LTP truncate test case passed.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Cc: David Howells <dhowells@redhat.com>
---
 fs/ramfs/file-nommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index 3b481d5..9345a46 100644
--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -179,7 +179,7 @@ static int ramfs_nommu_resize(struct inode *inode, loff_t newsize, loff_t size)
                        return ret;
        }
 
-       ret = vmtruncate(inode, size);
+       ret = vmtruncate(inode, newsize);
 
        return ret;
 }
-- 
1.5.2
