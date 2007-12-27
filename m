Return-Path: <linux-kernel-owner+w=401wt.eu-S1752871AbXL0FWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbXL0FWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 00:22:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750894AbXL0FWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 00:22:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47344 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbXL0FWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 00:22:05 -0500
Date: Thu, 27 Dec 2007 06:21:57 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc6-mm1: __raw_spin_is_contended undefined
Message-ID: <20071227052157.GA2146@wotan.suse.de>
References: <20071222233056.d652743e.akpm@linux-foundation.org> <20071227022158.GA10204@nineveh.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071227022158.GA10204@nineveh.local>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 26, 2007 at 09:21:58PM -0500, Joseph Fannin wrote:
> On Sat, Dec 22, 2007 at 11:30:56PM -0800, Andrew Morton wrote:
> >
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc6/2.6.24-rc6-mm1/
> >
> 
> This doesn't build on powerpc with my .config:
> 
> In file included from arch/powerpc/kernel/asm-offsets.c:17:
> include/linux/sched.h: In function ???spin_needbreak???:
> include/linux/sched.h:1947: error: implicit declaration of function ???__raw_spin_is_contended???
> 
> I don't see where __raw_spin_is_contended is defined for any arch
> other than x86, so I guess this will happen on any non-x86 arch when
> SMP=y and PREEMPT=y are set?

And CONFIG_GENERIC_LOCKBREAK is not defined, which is what powerpc needs.

Thanks for reporting,
Nick

---

Index: linux-2.6/arch/powerpc/Kconfig
===================================================================
--- linux-2.6.orig/arch/powerpc/Kconfig
+++ linux-2.6/arch/powerpc/Kconfig
@@ -53,6 +53,11 @@ config RWSEM_XCHGADD_ALGORITHM
 	bool
 	default y
 
+config GENERIC_LOCKBREAK
+	bool
+	default y
+	depends on SMP && PREEMPT
+
 config ARCH_HAS_ILOG2_U32
 	bool
 	default y
