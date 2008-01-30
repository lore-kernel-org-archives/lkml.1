Return-Path: <linux-kernel-owner+w=401wt.eu-S1757252AbYA3Tbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252AbYA3Tbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 14:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbYA3TbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 14:31:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36071 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbYA3TbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:31:20 -0500
Date: Wed, 30 Jan 2008 20:30:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       linux-ia64@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: x86/non-x86: percpu, node ids, apic ids x86.git fixup
Message-ID: <20080130193039.GB11506@elte.hu>
References: <200801301414.m0UEEgCC006371@hera.kernel.org> <Pine.LNX.4.64.0801301622460.11859@vixen.sonytel.be> <47A09F8A.3000309@sgi.com> <20080130161036.GA12293@elte.hu> <1FE6DD409037234FAB833C420AA843EC757C72@orsmsx424.amr.corp.intel.com> <20080130180623.GA24881@elte.hu> <1FE6DD409037234FAB833C420AA843EC757DEA@orsmsx424.amr.corp.intel.com> <47A0CD4B.5040706@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A0CD4B.5040706@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> Could this be a problem with:
> 
> #ifdef HAVE_MODEL_SMALL_ATTRIBUTE
> # define PER_CPU_ATTRIBUTES     __attribute__((__model__ (__small__)))
> #endif
> 
> This is only defined for !__ASSEMBLY__

nope, moving that per the patch below did not resolve the link problems.

	Ingo

-------------->
Subject: ia64: build fix #3
From: Ingo Molnar <mingo@elte.hu>

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-ia64/percpu.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-x86.q/include/asm-ia64/percpu.h
===================================================================
--- linux-x86.q.orig/include/asm-ia64/percpu.h
+++ linux-x86.q/include/asm-ia64/percpu.h
@@ -8,6 +8,10 @@
 
 #define PERCPU_ENOUGH_ROOM PERCPU_PAGE_SIZE
 
+#ifdef HAVE_MODEL_SMALL_ATTRIBUTE
+# define PER_CPU_ATTRIBUTES	__attribute__((__model__ (__small__)))
+#endif
+
 #ifdef __ASSEMBLY__
 # define THIS_CPU(var)	(per_cpu__##var)  /* use this to mark accesses to per-CPU variables... */
 #else /* !__ASSEMBLY__ */
@@ -15,10 +19,6 @@
 
 #include <linux/threads.h>
 
-#ifdef HAVE_MODEL_SMALL_ATTRIBUTE
-# define PER_CPU_ATTRIBUTES	__attribute__((__model__ (__small__)))
-#endif
-
 #ifdef CONFIG_SMP
 
 #define __my_cpu_offset	__ia64_per_cpu_var(local_per_cpu_offset)
