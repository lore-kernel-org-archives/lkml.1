Return-Path: <linux-kernel-owner+w=401wt.eu-S1751465Ab0AHFkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465Ab0AHFkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 00:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934Ab0AHFkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 00:40:45 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:47156 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab0AHFkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 00:40:45 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: stable@kernel.org, stable-review@kernel.org, linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] kernel/sysctl.c: fix stable merge error in NOMMU mmap_min_addr
Date: Fri,  8 Jan 2010 00:40:42 -0500
Message-Id: <1262929242-7175-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100107175809.GA17276@suse.de>
References: <20100107175809.GA17276@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stable commit 0399123f3dcce1a515d021107ec0fb4413ca3efa didn't match the
original upstream commit.  The CONFIG_MMU check was added much too early
in the list disabling a lot of proc entries in the process.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 kernel/sysctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index dd84be9..b8bd058 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1200,7 +1200,6 @@ static struct ctl_table vm_table[] = {
 		.extra2		= (void *)&hugetlb_infinity,
 	},
 #endif
-#ifdef CONFIG_MMU
 	{
 		.ctl_name	= VM_LOWMEM_RESERVE_RATIO,
 		.procname	= "lowmem_reserve_ratio",
@@ -1346,6 +1345,7 @@ static struct ctl_table vm_table[] = {
 		.strategy	= &sysctl_jiffies,
 	},
 #endif
+#ifdef CONFIG_MMU
 	{
 		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "mmap_min_addr",
-- 
1.6.6

