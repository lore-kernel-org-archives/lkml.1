Return-Path: <linux-kernel-owner+w=401wt.eu-S1032889AbXHMSPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032889AbXHMSPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 14:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S974264AbXHMR7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 13:59:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49906 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S974333AbXHMR72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 13:59:28 -0400
Date: Mon, 13 Aug 2007 23:41:45 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: "Luck, Tony" <tony.luck@intel.com>
cc: Avi Kivity <avi@qumranet.com>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, kvm-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: kvm warning
In-Reply-To: <617E1C2C70743745A92448908E030B2A0224CFEF@scsmsx411.amr.corp.intel.com>
Message-ID: <alpine.LFD.0.999.0708132339431.29609@enigma.security.iitk.ac.in>
References: <20070808151446.9a4eebda.akpm@linux-foundation.org>
 <20070808221956.GA16238@elte.hu> <46BA4827.3080907@qumranet.com>
 <20070808155901.bcb249d9.akpm@linux-foundation.org> <46BA4D12.8090301@qumranet.com>
 <a781481a0708131031k7e2bcc18t3fd0e7709e14d4a2@mail.gmail.com>
 <617E1C2C70743745A92448908E030B2A0224CFEF@scsmsx411.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 13 Aug 2007, Luck, Tony wrote:

> > Solution (1) above sounds preferable, unless there are mysterious reasons
> > why ia64 wants to avoid Kconfig.preempt (adding Tony Luck to Cc:).
> 
> Send me a patch and unless it causes more problems than it solves, I'll
> put it in.


[PATCH] ia64: Include Kconfig.preempt

arch/ia64/Kconfig failed to include kernel/Kconfig.preempt that meant it
did not support PREEMPT_VOLUNTARY and PREEMPT_BKL (inadvertently).
This was recently noticed when the newly-added PREEMPT_NOTIFIERS in
Kconfig.preempt that was "select"ed from drivers/kvm/Kconfig (therefore)
started giving bogus warnings ('select' used by config symbol 'KVM' refers
to undefined symbol 'PREEMPT_NOTIFIERS') on ia64 builds.

So let's remove the open-coded definition of CONFIG_PREEMPT in
arch/ia64/Kconfig and replace it with just including Kconfig.preempt
instead, like the other archs do.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 arch/ia64/Kconfig |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 21aa4fc..8c39913 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -327,17 +327,7 @@ config FORCE_CPEI_RETARGET
 	This option it useful to enable this feature on older BIOS's as well.
 	You can also enable this by using boot command line option force_cpei=1.
 
-config PREEMPT
-	bool "Preemptible Kernel"
-        help
-          This option reduces the latency of the kernel when reacting to
-          real-time or interactive events by allowing a low priority process to
-          be preempted even if it is in kernel mode executing a system call.
-          This allows applications to run more reliably even when the system is
-          under load.
-
-          Say Y here if you are building a kernel for a desktop, embedded
-          or real-time system.  Say N if you are unsure.
+source "kernel/Kconfig.preempt"
 
 source "mm/Kconfig"
 
