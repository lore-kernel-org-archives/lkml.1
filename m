Return-Path: <linux-kernel-owner+w=401wt.eu-S1753260AbZGNDTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbZGNDTR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 23:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbZGNDTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 23:19:16 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45037 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbZGNDTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 23:19:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4A5BF922.2000503@jp.fujitsu.com>
Date: Tue, 14 Jul 2009 12:18:58 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, kexec-ml <kexec@lists.infradead.org>
Subject: [PATCH] kexec: Fix omitting offset in extended crashkernel syntax
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting
 "crashkernel=512M-2G:64M,2G-:128M"
does not work but it turns to work if it has a trailing-whitespace,
like
 "crashkernel=512M-2G:64M,2G-:128M ".

It was because of a bug in the parser, running over the cmdline.

This patch adds a check of the termination.

Reported-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Tested-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
---
 kernel/kexec.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index ae1c352..f336e21 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1228,7 +1228,7 @@ static int __init parse_crashkernel_mem(char 			*cmdline,
 	} while (*cur++ == ',');
 
 	if (*crash_size > 0) {
-		while (*cur != ' ' && *cur != '@')
+		while (*cur && *cur != ' ' && *cur != '@')
 			cur++;
 		if (*cur == '@') {
 			cur++;
-- 
1.6.0

