Return-Path: <linux-kernel-owner+w=401wt.eu-S965999AbZLHUNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965999AbZLHUNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 15:13:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756266AbZLHUNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 15:13:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:40888 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965978AbZLHUNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 15:13:09 -0500
Date: Tue, 8 Dec 2009 20:12:40 GMT
From: tip-bot for Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andi@firstfloor.org, seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de
In-Reply-To: <4B1E05CC.4040703@jp.fujitsu.com>
References: <4B1E05CC.4040703@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, mce: fix confusion between bank attributes and mce attributes
Message-ID: <tip-5c0e9f28da84c68ce0ae68b7a75faaf862e156e2@git.kernel.org>
Git-Commit-ID: 5c0e9f28da84c68ce0ae68b7a75faaf862e156e2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5c0e9f28da84c68ce0ae68b7a75faaf862e156e2
Gitweb:     http://git.kernel.org/tip/5c0e9f28da84c68ce0ae68b7a75faaf862e156e2
Author:     Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
AuthorDate: Tue, 8 Dec 2009 16:52:44 +0900
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 8 Dec 2009 12:11:20 -0800

x86, mce: fix confusion between bank attributes and mce attributes

Commit cebe182033f156b430952370fb0f9dbe6e89b081 had an unnecessary,
wrong change: &mce_banks[i].attr is equivalent to the former
bank_attrs[i], not to mce_attrs[i].

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Acked-by: Andi Kleen <andi@firstfloor.org>
LKML-Reference: <4B1E05CC.4040703@jp.fujitsu.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index a96e5cd..a8aacd4 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1929,7 +1929,7 @@ error2:
 		sysdev_remove_file(&per_cpu(mce_dev, cpu), &mce_banks[j].attr);
 error:
 	while (--i >= 0)
-		sysdev_remove_file(&per_cpu(mce_dev, cpu), &mce_banks[i].attr);
+		sysdev_remove_file(&per_cpu(mce_dev, cpu), mce_attrs[i]);
 
 	sysdev_unregister(&per_cpu(mce_dev, cpu));
 
