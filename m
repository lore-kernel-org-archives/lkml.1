Return-Path: <linux-kernel-owner+w=401wt.eu-S1757154AbYGHBhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154AbYGHBhT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 21:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbYGHBhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 21:37:06 -0400
Received: from homer.mvista.com ([63.81.120.158]:21841 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754502AbYGHBhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 21:37:05 -0400
Message-ID: <4872C4C0.6040307@ct.jp.nec.com>
Date: Mon, 07 Jul 2008 18:37:04 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] softlockup: fix invalid proc_handler for softlockup_panic
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

The type of softlockup_panic is int, but the proc_handler is
proc_doulongvec_minmax(). This handler is for unsigned long.

This handler should be proc_dointvec_minmax().

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 kernel/sysctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 683986d..5b8b4c1 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -757,7 +757,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &softlockup_panic,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_doulongvec_minmax,
+		.proc_handler	= &proc_dointvec_minmax,
 		.strategy	= &sysctl_intvec,
 		.extra1		= &zero,
 		.extra2		= &one,
-- 
1.5.4.1

