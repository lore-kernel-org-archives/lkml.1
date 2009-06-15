Return-Path: <linux-kernel-owner+w=401wt.eu-S1758005AbZFOIUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005AbZFOIUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750993AbZFOIU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:20:28 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53059 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbZFOIU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:20:28 -0400
Message-ID: <4A360444.6010404@jp.fujitsu.com>
Date: Mon, 15 Jun 2009 17:20:20 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 03/16] x86, mce: add __read_mostly
References: <4A3601BF.2000201@jp.fujitsu.com>
In-Reply-To: <4A3601BF.2000201@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As recommended by Ingo Molnar.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 84b2630..d66f9f1 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -57,7 +57,7 @@ static void unexpected_machine_check(struct pt_regs *regs, long error_code)
 void (*machine_check_vector)(struct pt_regs *, long error_code) =
 						unexpected_machine_check;
 
-int				mce_disabled;
+int mce_disabled __read_mostly;
 
 #ifdef CONFIG_X86_NEW_MCE
 
@@ -76,19 +76,19 @@ DEFINE_PER_CPU(unsigned, mce_exception_count);
  *   2: SIGBUS or log uncorrected errors (if possible), log corrected errors
  *   3: never panic or SIGBUS, log all errors (for testing only)
  */
-static int			tolerant = 1;
-static int			banks;
-static u64			*bank;
-static unsigned long		notify_user;
-static int			rip_msr;
-static int			mce_bootlog = -1;
-static int			monarch_timeout = -1;
-static int			mce_panic_timeout;
-static int			mce_dont_log_ce;
-int				mce_cmci_disabled;
-int				mce_ignore_ce;
-int				mce_ser;
+static int			tolerant		__read_mostly = 1;
+static int			banks			__read_mostly;
+static u64			*bank			__read_mostly;
+static int			rip_msr			__read_mostly;
+static int			mce_bootlog		__read_mostly = -1;
+static int			monarch_timeout		__read_mostly = -1;
+static int			mce_panic_timeout	__read_mostly;
+static int			mce_dont_log_ce		__read_mostly;
+int				mce_cmci_disabled	__read_mostly;
+int				mce_ignore_ce		__read_mostly;
+int				mce_ser			__read_mostly;
 
+static unsigned long		notify_user;
 static char			trigger[128];
 static char			*trigger_argv[2] = { trigger, NULL };
 
-- 
1.6.3



