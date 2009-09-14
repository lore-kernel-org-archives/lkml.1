Return-Path: <linux-kernel-owner+w=401wt.eu-S1751524AbZINHCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbZINHCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 03:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750739AbZINHCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 03:02:31 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44234 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbZINHCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 03:02:30 -0400
Message-ID: <4AADEA82.8000500@np.css.fujitsu.com>
Date: Mon, 14 Sep 2009 16:02:26 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>, gregkh <gregkh@suse.de>
Cc: LKLM <linux-kernel@vger.kernel.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: [GIT BISECT -next] mem.c: could not login on console of fedora 10
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I build and boot -next on fedora 10, I can not login anymore.
When I input the user name and password, the system does not output
any message and requires user to input the user name and password
again and again.

I find the patch which caused this problem with "GIT BISECT" command.
And the patch is
    commit 7c4b7daa1878972ed0137c95f23569124bd6e2b1
    "mem_class: use minor as index instead of searching the array".

Though I don't know the real reason why user could not login, I
confirmed the patch I made as following could resolve the problem on
fedora 10.

Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
---
 drivers/char/mem.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index bed3503..0491cdf 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -878,8 +878,8 @@ static const struct memdev {
 	[ 4] = { "port", &port_fops, NULL },
 #endif
 	[ 5] = { "zero", &zero_fops, &zero_bdi },
-	[ 6] = { "full", &full_fops, NULL },
-	[ 7] = { "random", &random_fops, NULL },
+	[ 7] = { "full", &full_fops, NULL },
+	[ 8] = { "random", &random_fops, NULL },
 	[ 9] = { "urandom", &urandom_fops, NULL },
 	[11] = { "kmsg", &kmsg_fops, NULL },
 #ifdef CONFIG_CRASH_DUMP
-- 
1.6.2.2
