Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbYKUEFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbYKUEFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 23:05:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYKUEFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 23:05:06 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:42140 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920AbYKUEFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 23:05:05 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] autodetect_raid: add missing __init marking
Date: Thu, 20 Nov 2008 23:05:03 -0500
Message-Id: <1227240303-30591-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function autodetect_raid is only used by __init functions, and it refers
to __initdata, so it needs __init markings.  Fixes this error:
The function autodetect_raid() references
the variable __initdata raid_noautodetect.
This is often because autodetect_raid lacks a __initdata
annotation or the annotation of raid_noautodetect is wrong.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 init/do_mounts_md.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/do_mounts_md.c b/init/do_mounts_md.c
index d6da5cd..ff95e31 100644
--- a/init/do_mounts_md.c
+++ b/init/do_mounts_md.c
@@ -271,7 +271,7 @@ static int __init raid_setup(char *str)
 __setup("raid=", raid_setup);
 __setup("md=", md_setup);
 
-static void autodetect_raid(void)
+static void __init autodetect_raid(void)
 {
 	int fd;
 
-- 
1.6.0.4

