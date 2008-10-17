Return-Path: <linux-kernel-owner+w=401wt.eu-S1754301AbYJQJYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbYJQJYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 05:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbYJQJYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 05:24:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49338 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbYJQJYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 05:24:14 -0400
Message-ID: <48F85976.4070609@cn.fujitsu.com>
Date: Fri, 17 Oct 2008 17:23:02 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Russell King <rmk+kernel@arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix debugfs_create_dir's error checking method for arm/plat-omap
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

debugfs_create_dir() returns NULL if an error occurs, returns -ENODEV
when debugfs is not enabled in the kernel.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 arch/arm/plat-omap/clock.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-omap/clock.c b/arch/arm/plat-omap/clock.c
index bf6a10c..0767985 100644
--- a/arch/arm/plat-omap/clock.c
+++ b/arch/arm/plat-omap/clock.c
@@ -483,6 +483,8 @@ static int __init clk_debugfs_init(void)
 	int err;
 
 	d = debugfs_create_dir("clock", NULL);
+	if (!d)
+		return -ENOMEM;
 	if (IS_ERR(d))
 		return PTR_ERR(d);
 	clk_debugfs_root = d;
-- 
1.5.5.3


