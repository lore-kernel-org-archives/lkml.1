Return-Path: <linux-kernel-owner+w=401wt.eu-S1758842AbZC0GOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842AbZC0GOt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 02:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbZC0GOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 02:14:40 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:57734 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750915AbZC0GOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 02:14:40 -0400
Date: Fri, 27 Mar 2009 15:14:38 +0900
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: jeremy@goop.org
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [PATCH] xen/balloon: remove a warning.
Message-ID: <20090327061438.GL13054%yamahata@valinux.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the following warning on ia64.

drivers/xen/balloon.c: In function 'show_target':
drivers/xen/balloon.c:516: warning: format '%llu' expects type 'long long unsigned int', but argument 3 has type 'long unsigned int'

Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
---
 drivers/xen/balloon.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index efa4b36..b989ba6 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -513,7 +513,8 @@ static ssize_t show_target(struct sys_device *dev, struct sysdev_attribute *attr
 			      char *buf)
 {
 	return sprintf(buf, "%llu\n",
-		       (u64)balloon_stats.target_pages << PAGE_SHIFT);
+		       (unsigned long long)balloon_stats.target_pages <<
+		       PAGE_SHIFT);
 }
 
 static ssize_t store_target(struct sys_device *dev,
-- 
1.6.0.2


