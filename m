Return-Path: <linux-kernel-owner+w=401wt.eu-S1754523AbZBCSOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbZBCSOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 13:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbZBCSOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 13:14:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41988 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbZBCSOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 13:14:36 -0500
Date: Tue, 3 Feb 2009 19:14:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen: fix 32-bit build resulting from mmu move
Message-ID: <20090203181425.GA4884@elte.hu>
References: <49876C6E.3010809@goop.org> <20090203122112.GD19979@elte.hu> <49887B79.4040708@goop.org> <20090203173612.GA3528@elte.hu> <49888787.30803@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49888787.30803@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> i have a lot of successful builds with that pattern, that's why i asked 
>> for a specific config from you that definitely triggers it - i'd like 
>> to investigate how it escaped my testing procedures.
>>   
>
> Hm, I don't see how you could be; the functions are just outright  
> missing.  Without the patch, the attached config fails with:
>
> $ make 'ARCH=i386' arch/x86/xen/mmu.o
> [...]
>  CC      arch/x86/xen/mmu.o
> /home/jeremy/hg/xen/paravirt/linux/arch/x86/xen/mmu.c:1810: error: 'xen_kmap_atomic_pte' undeclared here (not in a function)
> /home/jeremy/hg/xen/paravirt/linux/arch/x86/xen/mmu.c:1816: error: 'xen_set_pte_init' undeclared here (not in a function)
> /home/jeremy/hg/xen/paravirt/linux/arch/x86/xen/mmu.c:1824: error: initializer element is not constant
> /home/jeremy/hg/xen/paravirt/linux/arch/x86/xen/mmu.c:1824: error: (near initialization for 'xen_mmu_ops.pte_val')
> /home/jeremy/hg/xen/paravirt/linux/arch/x86/xen/mmu.c:1825: error: initializer element is not constant
> /home/jeremy/hg/xen/paravirt/linux/arch/x86/xen/mmu.c:1825: error: (near initialization for 'xen_mmu_ops.pgd_val')
> /home/jeremy/hg/xen/paravirt/linux/arch/x86/xen/mmu.c:1827: error: initializer element is not constant
> /home/jeremy/hg/xen/paravirt/linux/arch/x86/xen/mmu.c:1827: error: (near initialization for 'xen_mmu_ops.make_pte')
> /home/jeremy/hg/xen/paravirt/linux/arch/x86/xen/mmu.c:1828: error: initializer element is not constant
> /home/jeremy/hg/xen/paravirt/linux/arch/x86/xen/mmu.c:1828: error: (near initialization for 'xen_mmu_ops.make_pgd')
> /home/jeremy/hg/xen/paravirt/linux/arch/x86/xen/mmu.c:1838: error: initializer element is not constant
> /home/jeremy/hg/xen/paravirt/linux/arch/x86/xen/mmu.c:1838: error: (near initialization for 'xen_mmu_ops.make_pmd')
> /home/jeremy/hg/xen/paravirt/linux/arch/x86/xen/mmu.c:1839: error: initializer element is not constant
> /home/jeremy/hg/xen/paravirt/linux/arch/x86/xen/mmu.c:1839: error: (near initialization for 'xen_mmu_ops.pmd_val')
> make[3]: *** [arch/x86/xen/mmu.o] Error 1
> make[2]: *** [arch/x86/xen/mmu.o] Error 2
> make[1]: *** [sub-make] Error 2
> make: *** [all] Error 2
>

hm, it triggers here too. Maybe the count of 32-bit tests wasnt high enough 
yet to hit this.

	Ingo
