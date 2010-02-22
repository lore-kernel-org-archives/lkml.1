Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab0BVShu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:37:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196Ab0BVShs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:37:48 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de, hjl.tools@gmail.com,
       linux-tip-commits@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: [tip:x86/ptrace] ptrace: Add support for generic
 PTRACE_GETREGSET/PTRACE_SETREGSET
In-Reply-To: Ingo Molnar's message of  Monday, 22 February 2010 10:07:10 +0100 <20100222090710.GA31357@elte.hu>
References: <20100211195614.886724710@sbs-t61.sc.intel.com>
	<tip-2225a122ae26d542bdce523d9d87a4a7ba10e07b@git.kernel.org>
	<20100222090710.GA31357@elte.hu>
X-Shopping-List: (1) Heroic rectums
   (2) Indolent bag lunches
   (3) Carbonated travesty
   (4) Polemical briefs
   (5) Symbolical putty redeemers
Message-Id: <20100222183707.8749D64C@magilla.sf.frob.com>
Date: Mon, 22 Feb 2010 10:37:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> FYI, this commit broke tip:master on PARISC (other architectures are fine):
> 
>  kernel/built-in.o: In function `ptrace_request':
>  (.text.ptrace_request+0x2cc): undefined reference to `task_user_regset_view'

This means that parisc failed to meet the documented requirements for
setting CONFIG_HAVE_ARCH_TRACEHOOK, but set it anyway.  If arch folks don't
follow the specs, it defeats the whole purpose of having clear statements
of requirements for arch code.

> I'll keep them in tip:master to get them tested, but note that i cannot push 
> any of these patches into linux-next until this is fixed, as linux-next 
> requires all architectures to build, with no regard to which architectures are 
> tested by kernel testers in practice.

IMHO if parisc does not finish up its requirements RSN, it should instead:

diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 524d935..f388dc6 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -18,7 +18,6 @@ config PARISC
 	select BUG
 	select HAVE_PERF_EVENTS
 	select GENERIC_ATOMIC64 if !64BIT
-	select HAVE_ARCH_TRACEHOOK
 	help
 	  The PA-RISC microprocessor is designed by Hewlett-Packard and used
 	  in many of their workstations & servers (HP9000 700 and 800 series,


Thanks,
Roland
