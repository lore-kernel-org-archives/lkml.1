Return-Path: <linux-kernel-owner+w=401wt.eu-S1752002AbYAOMbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbYAOMbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 07:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750906AbYAOMbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 07:31:10 -0500
Received: from smtp.movial.fi ([62.236.91.34]:45677 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbYAOMbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 07:31:08 -0500
X-Greylist: delayed 1707 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jan 2008 07:31:08 EST
Date: Tue, 15 Jan 2008 14:02:39 +0200
From: Adrian Bunk <adrian.bunk@movial.fi>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Randy Dunlap <randy.dunlap@oracle.com>, phil.el@wanadoo.fr,
       oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Fwd: Re: [2.6.24 patch] restore ARMv6 OProfile support
Message-ID: <20080115120239.GA14260@movial.fi>
References: <20071228195841.GA3945@flint.arm.linux.org.uk> <20080115104526.GA32067@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080115104526.GA32067@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 10:45:26AM +0000, Russell King wrote:
> I never got a response on my message, but I have just receieved:
> 
> | Date: Tue, 15 Jan 2008 11:05:00 +0100
> | From: Joerg Wagner <wagner@it.neclab.eu>
> | To: ARM Linux Mailing List <linux-arm-kernel@lists.arm.linux.org.uk>
> | Subject: 2.6.24-rc7 : oprofile on MPCore broken
> | 
> | Hello,
> | 
> | just tried to use oprofile on 2.6.24-rc7.
> | It does not detect the right processor
> |  (/dev/oprofile/cpu_type contains "timer").
> | 
> | As I don't know exactly, how the string
> | "arm/mpcore" from arch/arm/oprofile/op_model_mpcore.c
> | gets feeded into that file, maybe someone else can help ?
> 
> So people are hitting the resulting mess created by 09cadedbdc01f1a4bea1f427d4fb4642eaa19da9.
> Can we please fix this regression one way or another please?
> 
> I don't particularly like stuffing the options into some random place
> in the architectures Kconfig file when they should stay along side the
> instrumentation configuration entries.

Below is the patch I already sent on 28 Dec 2007 that stuffs it into 
Kconfig.instrumentation.

Technically it shouldn't make any difference whether this patch or
Mathieu's patch that stuffs it into arch/arm/Kconfig gets applied, but 
one of them should be applied for 2.6.24 (plus either mine or Mathieu's 
fix for the blackfin HARDWARE_PM support broken by the same commit).

I found the bugs in Mathieu's commit 09cadedbdc01f1a4bea1f427d4fb4642eaa19da9,
I wrote patches that restore the status quo, Cc'ed all people even
remotely related to this issue, and I opened the Bugzilla bugs required
for getting them on the regression lists. Mathieu wants the regressions
he introduced fixed different from what my patches did and that's not a
problem for me (his patches are also OK).

What went wrong that his regression fixes did not land in Linus' tree?

cu
Adrian


<--  snip  -->


This patch restores the ARMv6 OProfile support that was killed by
commit 09cadedbdc01f1a4bea1f427d4fb4642eaa19da9.

Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>

---

 kernel/Kconfig.instrumentation |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

7fc221ef169610b5eac98e2ddd641811c0d53e4a 
diff --git a/kernel/Kconfig.instrumentation b/kernel/Kconfig.instrumentation
index 468f47a..4453187 100644
--- a/kernel/Kconfig.instrumentation
+++ b/kernel/Kconfig.instrumentation
@@ -29,2 +29,17 @@ config OPROFILE

+config OPROFILE_ARMV6
+	bool
+	depends on OPROFILE && ARM && CPU_V6 && !SMP
+	default y
+	select OPROFILE_ARM11_CORE
+
+config OPROFILE_MPCORE
+	bool
+	depends on OPROFILE && ARM && CPU_V6 && SMP
+	default y
+	select OPROFILE_ARM11_CORE
+
+config OPROFILE_ARM11_CORE
+	bool
+
 config KPROBES
