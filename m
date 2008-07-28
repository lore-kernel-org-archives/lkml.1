Return-Path: <linux-kernel-owner+w=401wt.eu-S1759405AbYG1BFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759405AbYG1BFU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 21:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756370AbYG1BFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 21:05:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40079 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755951AbYG1BFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 21:05:07 -0400
Date: Mon, 28 Jul 2008 11:05:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Badari Pulavarty <pbadari@us.ibm.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] more sysdev API change fallout - drivers/base/memory.c
Message-Id: <20080728110504.41531146.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed because of this warning:

drivers/base/memory.c:279: warning: initialization from incompatible
pointer type

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/base/memory.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 3ad49a0..af0d175 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -103,7 +103,8 @@ static ssize_t show_mem_phys_index(struct sys_device *dev,
 /*
  * Show whether the section of memory is likely to be hot-removable
  */
-static ssize_t show_mem_removable(struct sys_device *dev, char *buf)
+static ssize_t show_mem_removable(struct sys_device *dev,
+			struct sysdev_attribute *attr, char *buf)
 {
 	unsigned long start_pfn;
 	int ret;
-- 
1.5.6.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
