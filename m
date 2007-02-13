Return-Path: <linux-kernel-owner+w=401wt.eu-S1751444AbXBMXrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444AbXBMXrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 18:47:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbXBMXrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 18:47:52 -0500
Received: from ms-smtp-05.texas.rr.com ([24.93.47.44]:44215 "EHLO
	ms-smtp-05.texas.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbXBMXrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 18:47:52 -0500
From: Eric Van Hensbergen <ericvh@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: v9fs-developer@lists.sourceforge.net,
       Eric Van Hensbergen <ericvh@gmail.com>
Subject: [PATCH] 9p: add write-cache support to loose cache mode
Date: Tue, 13 Feb 2007 17:47:47 -0600
Message-Id: <11714104673828-git-send-email-ericvh@gmail.com>
X-Mailer: git-send-email 1.5.0.rc1.gde38
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Loose cache mode was added primarily to asssist exclusive, read-only
mounts (like venti) -- however, there is also a case for using loose
write cacheing in support of read/write exclusive mounts.  This feature
is linked to the loose cache option and is disabled by default.

This code adds the necessary code to support writes through the page
cache.  Write caches are not used for synthetic files or for files opened
in APPEND mode.

Signed-of-by: Eric Van Hensbergen <ericvh@gmail.com>
---
 Documentation/filesystems/9p.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/filesystems/9p.txt b/Documentation/filesystems/9p.txt
index bbd8b28..36ed211 100644
--- a/Documentation/filesystems/9p.txt
+++ b/Documentation/filesystems/9p.txt
@@ -42,7 +42,7 @@ OPTIONS
 
   cache=mode	specifies a cacheing policy.  By default, no caches are used.
 			loose = no attempts are made at consistency,
-                                intended for exclusive, read-only mounts
+                                intended for exclusive mounts
 
   debug=n	specifies debug level.  The debug level is a bitmask.
   			0x01 = display verbose error messages
-- 
1.4.1

