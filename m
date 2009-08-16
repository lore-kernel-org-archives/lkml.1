Return-Path: <linux-kernel-owner+w=401wt.eu-S1752994AbZHPP2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbZHPP2r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 11:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750919AbZHPP2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 11:28:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:33537 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbZHPP2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 11:28:46 -0400
Date: Sun, 16 Aug 2009 15:27:45 GMT
From: tip-bot for Hugh Dickins <hugh.dickins@tiscali.co.uk>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andi@firstfloor.org, seto.hidetoshi@jp.fujitsu.com, dtor@mail.ru,
       tglx@linutronix.de, hugh.dickins@tiscali.co.uk, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, seto.hidetoshi@jp.fujitsu.com, dtor@mail.ru,
       tglx@linutronix.de, hugh.dickins@tiscali.co.uk, mingo@elte.hu
In-Reply-To: <Pine.LNX.4.64.0908161544100.7929@sister.anvils>
References: <Pine.LNX.4.64.0908161544100.7929@sister.anvils>
Subject: [tip:x86/urgent] x86, mce: therm_throt: Don't log redundant normality
Message-ID: <tip-4e5c25d405e18a2f279ca2bfc855508ec3a0186b@git.kernel.org>
Git-Commit-ID: 4e5c25d405e18a2f279ca2bfc855508ec3a0186b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 16 Aug 2009 15:27:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4e5c25d405e18a2f279ca2bfc855508ec3a0186b
Gitweb:     http://git.kernel.org/tip/4e5c25d405e18a2f279ca2bfc855508ec3a0186b
Author:     Hugh Dickins <hugh.dickins@tiscali.co.uk>
AuthorDate: Sun, 16 Aug 2009 15:54:37 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 16 Aug 2009 17:25:41 +0200

x86, mce: therm_throt: Don't log redundant normality

0d01f31439c1e4d602bf9fdc924ab66f407f5e38 "x86, mce: therm_throt
- change when we print messages" removed redundant
announcements of "Temperature/speed normal".

They're not worth logging and remove their accompanying
"Machine check events logged" messages as well from the
console.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
LKML-Reference: <Pine.LNX.4.64.0908161544100.7929@sister.anvils>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 8bc64cf..5957a93 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -116,11 +116,14 @@ static int therm_throt_process(int curr)
 		       cpu, __get_cpu_var(thermal_throttle_count));
 
 		add_taint(TAINT_MACHINE_CHECK);
-	} else if (was_throttled) {
+		return 1;
+	}
+	if (was_throttled) {
 		printk(KERN_INFO "CPU%d: Temperature/speed normal\n", cpu);
+		return 1;
 	}
 
-	return 1;
+	return 0;
 }
 
 #ifdef CONFIG_SYSFS
