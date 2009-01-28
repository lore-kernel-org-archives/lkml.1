Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944AbZA1DrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbZA1DrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 22:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbZA1DrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 22:47:12 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:41092 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752238AbZA1DrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 22:47:11 -0500
From: Bron Gondwana <brong@fastmail.fm>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@suse.de>, Davide Libenzi <davidel@xmailserver.org>,
       Bron Gondwana <brong@fastmail.fm>
Subject: [PATCH 1/3] epoll: increase default max_user_instances to 1024
Date: Wed, 28 Jan 2009 14:47:07 +1100
Message-Id: <59410684d947bc68862a4f5d6c2a5bb1f29519ee.1233114169.git.brong@fastmail.fm>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20090128033824.GA1662@brong.net>
References: <20090128033824.GA1662@brong.net>
In-Reply-To: <20090128033824.GA1662@brong.net>
References: <20090128033824.GA1662@brong.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both Postfix and Apache use an epoll instance per child, which
leads to significant scalability issues with max_user_instances
set so low.  Bump the default to 1024 so medium sized sites are
not impacted.

Signed-off-by: Bron Gondwana <brong@fastmail.fm>
---
 Documentation/filesystems/proc.txt |    6 +++++-
 fs/eventpoll.c                     |    2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index bbebc3a..4677abf 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -2237,9 +2237,13 @@ max_user_instances
 ------------------
 
 This is the maximum number of epoll file descriptors that a single user can
-have open at a given time. The default value is 128, and should be enough
+have open at a given time. The default value is 1024, and should be enough
 for normal users.
 
+If you are running a heavily loaded Postfix or Apache server, you may need
+to set this higher.  Both these servers run an epoll instance per child 
+process.
+
 max_user_watches
 ----------------
 
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index ba2f9ec..16eb817 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1366,7 +1366,7 @@ static int __init eventpoll_init(void)
 	struct sysinfo si;
 
 	si_meminfo(&si);
-	max_user_instances = 128;
+	max_user_instances = 1024;
 	max_user_watches = (((si.totalram - si.totalhigh) / 32) << PAGE_SHIFT) /
 		EP_ITEM_COST;
 
-- 
1.5.6.3

