Return-Path: <linux-kernel-owner+w=401wt.eu-S1751415AbZLVACq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415AbZLVACq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 19:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbZLVACp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 19:02:45 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:11208 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbZLVACo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 19:02:44 -0500
Date: Tue, 22 Dec 2009 00:02:45 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Subject: perf tools symbol_conf: use_modules/try_vmlinux_path
Message-ID: <20091221235943.GA23973@gallagher>
Mail-Followup-To: Jamie Iles <jamie@jamieiles.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 75be6cf (perf symbols: Make symbol_conf global) does what it says
on the tin, but also initialises the member fields use_modules and
try_vmlinux_path to true rather than the 'false' value they would have
had when symbol_conf was static.

When there is no vmlinux on the system and modules loaded, perf top will
not show any kernel symbols and perf report will only list raw IP's
rather than symbol names. Unloading the modules will give normal output.

The patch below fixes the problem for my box with no vmlinux and still
works on my desktop with a vmlinux present but I don't understand the
symbol code in perf enough to be sure that this is 100% correct.

Jamie

[PATCH] perf symbols: don't use modules or try vmlinux unless needed

Commit 75be6cf (perf symbols: Make symbol_conf global) does what it says
on the tin, but also initialises the member fields use_modules and
try_vmlinux_path to true rather than the 'false' value they would have
had when symbol_conf was static.

Restore previous behaviour by initialising these fields to false.

Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 tools/perf/util/symbol.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index ab92763..be9f17b 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -39,8 +39,8 @@ static char **vmlinux_path;
 
 struct symbol_conf symbol_conf = {
 	.exclude_other	  = true,
-	.use_modules	  = true,
-	.try_vmlinux_path = true,
+	.use_modules	  = false,
+	.try_vmlinux_path = false,
 };
 
 bool dso__loaded(const struct dso *self, enum map_type type)
-- 
1.6.5.2
