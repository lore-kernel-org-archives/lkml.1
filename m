Return-Path: <linux-kernel-owner+w=401wt.eu-S1758612AbZIOTRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612AbZIOTRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758534AbZIOTPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:15:05 -0400
Received: from kroah.org ([198.145.64.141]:33049 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758525AbZIOTO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:14:59 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jin Dongming <jin.dongming@np.css.fujitsu.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/20] mem_class: fix bug
Date: Tue, 15 Sep 2009 12:12:43 -0700
Message-Id: <1253041976-1111-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090915181247.GA32167@kroah.com>
References: <20090915181247.GA32167@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jin Dongming <jin.dongming@np.css.fujitsu.com>

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
Acked-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.6.4.2

