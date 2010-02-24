Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095Ab0BXNg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 08:36:28 -0500
Received: from mail-fx0-f216.google.com ([209.85.220.216]:43911 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757030Ab0BXNg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 08:36:27 -0500
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Feb 2010 08:36:26 EST
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: containers@lists.linux-foundation.org, Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org,
       "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH -mmotm] cgroup: fix typo in error handling in cgroup_write_event_control()
Date: Wed, 24 Feb 2010 15:31:08 +0200
Message-Id: <1267018268-16254-1-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.6.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually, we want to fput() cfile, if cfile is not NULL.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 kernel/cgroup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index d142524..049ce0d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3117,7 +3117,7 @@ static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
 	return 0;
 
 fail:
-	if (!cfile)
+	if (cfile)
 		fput(cfile);
 
 	if (event && event->eventfd && !IS_ERR(event->eventfd))
-- 
1.6.6.2

