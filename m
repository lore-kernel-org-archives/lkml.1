Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743AbZHZGXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbZHZGXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbZHZGXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:23:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:50931 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbZHZGXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:23:11 -0400
Date: Wed, 26 Aug 2009 06:22:42 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090824175551.146070377@openvz.org>
References: <20090824175551.146070377@openvz.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/setup] x86, e820: Guard against array overflowed in __e820_add_region()
Message-ID: <tip-5051fd69773d2d044734b78516317a04d3774871@git.kernel.org>
Git-Commit-ID: 5051fd69773d2d044734b78516317a04d3774871
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 26 Aug 2009 06:22:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5051fd69773d2d044734b78516317a04d3774871
Gitweb:     http://git.kernel.org/tip/5051fd69773d2d044734b78516317a04d3774871
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Mon, 24 Aug 2009 21:53:37 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 26 Aug 2009 08:17:47 +0200

x86, e820: Guard against array overflowed in __e820_add_region()

Better to be paranoid against unpredicted nr_map modifications.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
LKML-Reference: <20090824175551.146070377@openvz.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/e820.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 7271fa3..2e5e0fa 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -115,7 +115,7 @@ static void __init __e820_add_region(struct e820map *e820x, u64 start, u64 size,
 {
 	int x = e820x->nr_map;
 
-	if (x == ARRAY_SIZE(e820x->map)) {
+	if (x >= ARRAY_SIZE(e820x->map)) {
 		printk(KERN_ERR "Ooops! Too many entries in the memory map!\n");
 		return;
 	}
