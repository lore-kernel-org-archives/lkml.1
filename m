Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338AbZF0VuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbZF0VuR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 17:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbZF0VuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 17:50:06 -0400
Received: from aun.it.uu.se ([130.238.12.36]:37643 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbZF0VuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 17:50:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19014.37845.373626.810453@pilspetsen.it.uu.se>
Date: Sat, 27 Jun 2009 23:49:09 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       grundler@parisc-linux.org, tglx@linutronix.de, mikpe@it.uu.se
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] Revert "x86: cap iomem_resource to addressable physical memory"
In-Reply-To: <tip-fc1dbec8ae1a451557ade978bf7777b267690ca9@git.kernel.org>
References: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se>
	<tip-fc1dbec8ae1a451557ade978bf7777b267690ca9@git.kernel.org>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tip-bot for H. Peter Anvin writes:
 > Commit-ID:  fc1dbec8ae1a451557ade978bf7777b267690ca9
 > Gitweb:     http://git.kernel.org/tip/fc1dbec8ae1a451557ade978bf7777b267690ca9
 > Author:     H. Peter Anvin <hpa@zytor.com>
 > AuthorDate: Sat, 27 Jun 2009 12:22:27 -0700
 > Committer:  H. Peter Anvin <hpa@zytor.com>
 > CommitDate: Sat, 27 Jun 2009 12:22:27 -0700
 > 
 > Revert "x86: cap iomem_resource to addressable physical memory"
 > 
 > This reverts commit 95ee14e4379c5e19c0897c872350570402014742.
 > Mikael Petterson <mikpe@it.uu.se> reported that at least one of his
 > systems will not boot as a result.  We have ruled out the detection
 > algorithm malfunctioning, so it is not a matter of producing the
 > incorrect bitmasks; rather, something in the application of them
 > fails.
 > 
 > Revert the commit until we can root cause and correct this problem.
 > 
 > -stable team: this means the underlying commit should be rejected.
 > 
 > Reported-and-isolated-by: Mikael Petterson <mikepe@it.uu.se>

Typo, please s/mikepe/mikpe/ here.

 > Signed-off-by: H. Peter Anvin <hpa@zytor.com>
 > LKML-Reference: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se>
 > Cc: stable@kernel.org
 > Cc: Grant Grundler <grundler@parisc-linux.org>
 > 
 > 
 > ---
 >  arch/x86/kernel/cpu/common.c |    3 ---
 >  1 files changed, 0 insertions(+), 3 deletions(-)
 > 
 > diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
 > index 6b26d4d..f1961c0 100644
 > --- a/arch/x86/kernel/cpu/common.c
 > +++ b/arch/x86/kernel/cpu/common.c
 > @@ -848,9 +848,6 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 >  #if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
 >  	numa_add_cpu(smp_processor_id());
 >  #endif
 > -
 > -	/* Cap the iomem address space to what is addressable on all CPUs */
 > -	iomem_resource.end &= (1ULL << c->x86_phys_bits) - 1;
 >  }
 >  
 >  #ifdef CONFIG_X86_64
 > --
 > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
 > the body of a message to majordomo@vger.kernel.org
 > More majordomo info at  http://vger.kernel.org/majordomo-info.html
 > Please read the FAQ at  http://www.tux.org/lkml/
 > 
