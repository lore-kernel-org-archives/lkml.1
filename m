Return-Path: <linux-kernel-owner+w=401wt.eu-S1756915AbYHURgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbYHURgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 13:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbYHURfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 13:35:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:34160 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbYHURfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 13:35:52 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ingo Oeser <ioe-lkml@rameria.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 01/15] kobject: Replace ALL occurrences of '/' with '!' instead of only the first one.
Date: Thu, 21 Aug 2008 10:32:49 -0700
Message-Id: <1219339983-9634-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20080821173036.GB7974@suse.de>
References: <20080821173036.GB7974@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Oeser <ioe-lkml@rameria.de>

A recent patch from Kay Sievers <kay.sievers@vrfy.org>
replaced the first occurrence of '/' with '!' as needed for block devices.

Now do some cheap defensive coding and replace all of them to avoid future
issues in this area.

Signed-off-by: Ingo Oeser <ioe-lkml@rameria.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kobject.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index bd732ff..fbf0ae2 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -223,8 +223,7 @@ static int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
 		return -ENOMEM;
 
 	/* ewww... some of these buggers have '/' in the name ... */
-	s = strchr(kobj->name, '/');
-	if (s)
+	while ((s = strchr(kobj->name, '/')))
 		s[0] = '!';
 
 	kfree(old_name);
-- 
1.5.6.5

