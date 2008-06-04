Return-Path: <linux-kernel-owner+w=401wt.eu-S1757700AbYFDUsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700AbYFDUsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 16:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbYFDUsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 16:48:33 -0400
Received: from 1wt.eu ([62.212.114.60]:1439 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbYFDUsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 16:48:32 -0400
Date: Wed, 4 Jun 2008 22:47:03 +0200
From: Willy Tarreau <w@1wt.eu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] doc: add suggestions about good practises for maintainers
Message-ID: <20080604204703.GC9211@1wt.eu>
References: <20080603053446.GA27148@1wt.eu> <20080603152546.e6fb915e.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080603152546.e6fb915e.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your comments Randy.

Linus, please use the following one instead.

Thanks!
Willy
--

>From 2612e19e0827be56bd185a4cdd69bafaa05f8b46 Mon Sep 17 00:00:00 2001
From: Willy Tarreau <w@1wt.eu>
Date: Tue, 3 Jun 2008 00:20:28 +0200
Subject: doc: add suggestions about good practises for maintainers

Suggest how to deal with patch modifications caused by
merging or back-porting when you're a maintainer.

Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 Documentation/SubmittingPatches |   46 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index 9c93a03..118ca6e 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -327,6 +327,52 @@ Some people also put extra tags at the end.  They'll just be ignored for
 now, but you can do this to mark internal company procedures or just
 point out some special detail about the sign-off. 
 
+If you are a subsystem or branch maintainer, sometimes you need to slightly
+modify patches you receive in order to merge them, because the code is not
+exactly the same in your tree and the submitters'. If you stick strictly to
+rule (c), you should ask the submitter to rediff, but this is a totally
+counter-productive waste of time and energy. Rule (b) allows you to adjust
+the code, but then it is very impolite to change one submitter's code and
+make him endorse your bugs. To solve this problem, it is recommended that
+you add a line between the last Signed-off-by header and yours, indicating
+the nature of your changes. While there is nothing mandatory about this, it
+seems like prepending the description with your mail and/or name, all
+enclosed in square brackets, is noticeable enough to make it obvious that
+you are responsible for last-minute changes. Example :
+
+	Signed-off-by: Random J Developer <random@developer.example.org>
+	[lucky@maintainer.example.org: struct foo moved from foo.c to foo.h]
+	Signed-off-by: Lucky K Maintainer <lucky@maintainer.example.org>
+
+This practise is particularly helpful if you maintain a stable branch and
+want at the same time to credit the author, track changes, merge the fix,
+and protect the submitter from complaints. Note that under no circumstances
+can you change the author's identity (the From header), as it is the one
+which appears in the changelog.
+
+Special note to back-porters: It seems to be a common and useful practise
+to insert an indication of the origin of a patch at the top of the commit
+message (just after the subject line) to facilitate tracking. For instance,
+here's what we see in 2.6-stable :
+
+    Date:   Tue May 13 19:10:30 2008 +0000
+
+        SCSI: libiscsi regression in 2.6.25: fix nop timer handling
+
+        commit 4cf1043593db6a337f10e006c23c69e5fc93e722 upstream
+
+And here's what appears in 2.4 :
+
+    Date:   Tue May 13 22:12:27 2008 +0200
+
+        wireless, airo: waitbusy() won't delay
+
+        [backport of 2.6 commit b7acbdfbd1f277c1eb23f344f899cfa4cd0bf36a]
+
+Whatever the format, this information provides a valuable help to people
+tracking your trees, and to people trying to trouble-shoot bugs in your
+tree.
+
 
 13) When to use Acked-by: and Cc:
 
-- 
1.5.3.8

