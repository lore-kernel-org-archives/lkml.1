Return-Path: <linux-kernel-owner+w=401wt.eu-S935911AbXJQADP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935911AbXJQADP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 20:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935678AbXJQACx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 20:02:53 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44893 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935650AbXJQACw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 20:02:52 -0400
Date: Wed, 17 Oct 2007 01:02:46 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fix adbhid mismerge
Message-ID: <20071017000246.GE8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Something really odd has happened: the last couple of changesets
have
-       int up_flag;
+       int keycode, up_flag;
and
-       int up_flag;
+       int up_flag, key;
in another, both in adb_input_keycode().  Even with -m passed to
git-whatchanged there's no sign of anything in that area.

Aside of trivial conflict resolution (see below), what's the right
way to trace the things like that?  Linus?

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/macintosh/adbhid.c b/drivers/macintosh/adbhid.c
index 8cce016..2766e4f 100644
--- a/drivers/macintosh/adbhid.c
+++ b/drivers/macintosh/adbhid.c
@@ -282,7 +282,7 @@ static void
 adbhid_input_keycode(int id, int scancode, int repeat)
 {
 	struct adbhid *ahid = adbhid[id];
-	int keycode, up_flag;
+	int keycode, up_flag, key;
 
 	keycode = scancode & 0x7f;
 	up_flag = scancode & 0x80;
