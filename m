Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbYDIQmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbYDIQmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 12:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbYDIQmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 12:42:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbYDIQmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 12:42:08 -0400
To: linux-kernel@vger.kernel.org
Cc: Adrian Bunk <bunk@kernel.org>
Subject: [PATCH] printk: Don't read beyond string arguments' terminating zero
From: Markus Armbruster <armbru@redhat.com>
Date: Wed, 09 Apr 2008 18:41:33 +0200
Message-ID: <87fxtvx9oi.fsf@pike.pond.sub.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix add_preferred_console() and update_console_cmdline() not to to
read beyond the terminating zero of their name argument.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 kernel/printk.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index c46a20a..52526df 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -865,7 +865,7 @@ int add_preferred_console(char *name, int idx, char *options)
 		return -E2BIG;
 	selected_console = i;
 	c = &console_cmdline[i];
-	memcpy(c->name, name, sizeof(c->name));
+	strlcpy(c->name, name, sizeof(c->name));
 	c->name[sizeof(c->name) - 1] = 0;
 	c->options = options;
 	c->index = idx;
@@ -881,7 +881,7 @@ int update_console_cmdline(char *name, int idx, char *name_new, int idx_new, cha
 		if (strcmp(console_cmdline[i].name, name) == 0 &&
 			  console_cmdline[i].index == idx) {
 				c = &console_cmdline[i];
-				memcpy(c->name, name_new, sizeof(c->name));
+				strlcpy(c->name, name_new, sizeof(c->name));
 				c->name[sizeof(c->name) - 1] = 0;
 				c->options = options;
 				c->index = idx_new;
-- 
1.5.3.3

