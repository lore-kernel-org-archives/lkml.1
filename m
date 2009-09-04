Return-Path: <linux-kernel-owner+w=401wt.eu-S933709AbZIDOwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933709AbZIDOwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 10:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933695AbZIDOwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 10:52:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:46736 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933694AbZIDOv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 10:51:58 -0400
From: Michal Marek <mmarek@suse.cz>
To: sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       akpm@linux-foundation.org, Jan Beulich <JBeulich@novell.com>
Subject: [PATCH 2/2] kbuild: rebuild fix for Makefile.modbuiltin
Date: Fri,  4 Sep 2009 16:51:33 +0200
Message-Id: <3263f1a5a7e97b7db424ddd429698a23f8ec665b.1252075736.git.mmarek@suse.cz>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <7a5991a43c301eb402f67dc140c03aa1360e756e.1252075736.git.mmarek@suse.cz>
References: <cover.1252075736.git.mmarek@suse.cz>
 <7a5991a43c301eb402f67dc140c03aa1360e756e.1252075736.git.mmarek@suse.cz>
In-Reply-To: <cover.1252075736.git.mmarek@suse.cz>
References: <cover.1252075736.git.mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Beulich <JBeulich@novell.com>

This patch addresses an issue with rebuilds failing to re-generate
modules.builtin files after altering config options.

Signed-off-by: Jan Beulich <JBeulich@novell.com>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/Makefile.modbuiltin |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/scripts/Makefile.modbuiltin b/scripts/Makefile.modbuiltin
index 55e1885..cc39366 100644
--- a/scripts/Makefile.modbuiltin
+++ b/scripts/Makefile.modbuiltin
@@ -31,9 +31,13 @@ modbuiltin-cmds =						\
 	for m in $(modbuiltin-mods); do echo kernel/$$m; done;	\
 	cat /dev/null $(modbuiltin-subdirs);
 
-$(modbuiltin-target): $(subdir-ym)
+$(modbuiltin-target): $(subdir-ym) FORCE
 	$(Q)($(modbuiltin-cmds)) > $@
 
+PHONY += FORCE
+
+FORCE:
+
 # Descending
 # ---------------------------------------------------------------------------
 
-- 
1.6.3.3

