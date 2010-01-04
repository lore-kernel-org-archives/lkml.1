Return-Path: <linux-kernel-owner+w=401wt.eu-S1753171Ab0ADKXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab0ADKXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 05:23:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217Ab0ADKXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 05:23:46 -0500
Received: from mail2.picochip.com ([82.111.145.34]:45669 "EHLO
	thurne.picochip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751785Ab0ADKXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 05:23:45 -0500
From: Jamie Iles <jamie.iles@picochip.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie.iles@picochip.com>, Jamie Iles <jamie@jamieiles.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH] perf symbols: don't use modules or try vmlinux unless needed
Date: Mon,  4 Jan 2010 10:23:54 +0000
Message-Id: <1262600634-6628-1-git-send-email-jamie.iles@picochip.com>
X-Mailer: git-send-email 1.6.5.4
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (thurne.picochip.com [172.17.0.105]); Mon, 04 Jan 2010 10:22:41 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 75be6cf (perf symbols: Make symbol_conf global) does what it says
on the tin, but also initialises the member fields use_modules and
try_vmlinux_path to true rather than the 'false' value they would have
had when symbol_conf was static.

When there is no vmlinux on the system and modules loaded, perf top will
not show any kernel symbols and perf report will only list raw IP's
rather than symbol names. Unloading the modules will allow perf to give
normal output.

Restore previous behaviour by initialising these fields to false.

Signed-off-by: Jamie Iles <jamie@jamieiles.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
---
 tools/perf/util/symbol.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 79ca6a0..9467c29 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -40,8 +40,8 @@ static char **vmlinux_path;
 
 struct symbol_conf symbol_conf = {
 	.exclude_other	  = true,
-	.use_modules	  = true,
-	.try_vmlinux_path = true,
+	.use_modules	  = false,
+	.try_vmlinux_path = false,
 };
 
 bool dso__loaded(const struct dso *self, enum map_type type)
-- 
1.6.5.4

