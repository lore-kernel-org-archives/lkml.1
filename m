Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbYG0E0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbYG0E0w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 00:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbYG0E0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 00:26:45 -0400
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:36339 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbYG0E0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 00:26:44 -0400
Date: Sat, 26 Jul 2008 23:26:34 -0500
From: Nathan Lynch <ntl@pobox.com>
To: linux-kernel@vger.kernel.org
Cc: Badari Pulavarty <pbadari@us.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] drivers/base/memory.c: fix fallout from sysdev API changes
Message-ID: <20080727042633.GM9594@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Pobox-Relay-ID: 366FA0FE-5B94-11DD-A870-3113EBD4C077-04752483!a-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/base/memory.c:280: warning: initialization from incompatible pointer type

Signed-off-by: Nathan Lynch <ntl@pobox.com>
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
1.5.6.2

