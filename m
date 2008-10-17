Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbYJQNGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbYJQNGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 09:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbYJQNGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 09:06:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61278 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753500AbYJQNGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 09:06:16 -0400
Message-ID: <48F88D77.2080106@cn.fujitsu.com>
Date: Fri, 17 Oct 2008 21:04:55 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
       alsa-devel@alsa-project.org
Subject: [PATCH] Fix debugfs_create_dir's error checking method for sound/soc/
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
 sound/soc/soc-dapm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index efbd0b3..7351db9 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -831,7 +831,7 @@ int snd_soc_dapm_sys_add(struct device *dev)
 		return ret;
 
 	asoc_debugfs = debugfs_create_dir("asoc", NULL);
-	if (!IS_ERR(asoc_debugfs))
+	if (!IS_ERR(asoc_debugfs) && asoc_debugfs)
 		debugfs_create_u32("dapm_pop_time", 0744, asoc_debugfs,
 				   &pop_time);
 	else
-- 
1.5.5.3


