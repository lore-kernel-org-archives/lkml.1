Return-Path: <linux-kernel-owner+w=401wt.eu-S1755811AbZGUSeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbZGUSeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 14:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755559AbZGUSeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 14:34:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:42545 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755507AbZGUSeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 14:34:18 -0400
Date: Tue, 21 Jul 2009 18:33:45 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andi@firstfloor.org, jbeulich@novell.com, JBeulich@novell.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, jbeulich@novell.com, JBeulich@novell.com,
       tglx@linutronix.de
In-Reply-To: <4A5F04B7020000780000AB59@vpn.id2.novell.com>
References: <4A5F04B7020000780000AB59@vpn.id2.novell.com>
Subject: [tip:x86/urgent] x86, mce: Fix set_trigger() accessor
Message-ID: <tip-e9084ec98bb9aa3abc6cf73181177780ce7546f8@git.kernel.org>
Git-Commit-ID: e9084ec98bb9aa3abc6cf73181177780ce7546f8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Jul 2009 18:33:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e9084ec98bb9aa3abc6cf73181177780ce7546f8
Gitweb:     http://git.kernel.org/tip/e9084ec98bb9aa3abc6cf73181177780ce7546f8
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Thu, 16 Jul 2009 09:45:11 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 21 Jul 2009 10:49:18 -0700

x86, mce: Fix set_trigger() accessor

Fix the condition checking the result of strchr() (which previously
could result in an oops), and make the function return the number of
bytes actively used.

[ Impact: fix oops ]

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>
LKML-Reference: <4A5F04B7020000780000AB59@vpn.id2.novell.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>


---
 arch/x86/kernel/cpu/mcheck/mce.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 484c1e5..1cfb623 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1692,17 +1692,15 @@ static ssize_t set_trigger(struct sys_device *s, struct sysdev_attribute *attr,
 				const char *buf, size_t siz)
 {
 	char *p;
-	int len;
 
 	strncpy(mce_helper, buf, sizeof(mce_helper));
 	mce_helper[sizeof(mce_helper)-1] = 0;
-	len = strlen(mce_helper);
 	p = strchr(mce_helper, '\n');
 
-	if (*p)
+	if (p)
 		*p = 0;
 
-	return len;
+	return strlen(mce_helper) + !!p;
 }
 
 static ssize_t set_ignore_ce(struct sys_device *s,
