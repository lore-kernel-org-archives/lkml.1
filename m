Return-Path: <linux-kernel-owner+w=401wt.eu-S1756491AbXIFKlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491AbXIFKlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 06:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbXIFKlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 06:41:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbXIFKlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 06:41:13 -0400
Date: Thu, 6 Sep 2007 06:41:02 -0400
From: Dave Jones <davej@redhat.com>
To: Stefan Becker <Stefan.Becker@nokia.com>
Cc: ext Andi Kleen <andi@firstfloor.org>,
       ext Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [pre-2.6.23 REGRESSION] 2.6.23-rc3-git1 crash/stuck on VIA
	CN700 system
Message-ID: <20070906104102.GA14070@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Stefan Becker <Stefan.Becker@nokia.com>,
	ext Andi Kleen <andi@firstfloor.org>,
	ext Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
	linux-kernel@vger.kernel.org
References: <46C9D148.5080505@nokia.com> <p734pibbbex.fsf@bingen.suse.de> <46DDA366.8090806@nokia.com> <20070905102525.GB31880@one.firstfloor.org> <46DECDC9.9050407@nokia.com> <20070905163724.GC31880@one.firstfloor.org> <46DF0257.5050303@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46DF0257.5050303@nokia.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2007 at 10:24:07PM +0300, Stefan Becker wrote:

 > #if 0
 > 	if (cpu_has_clflush)
 > 		asm("clflush (%0) " :: "r" (addr) : "memory");
 > #endif
 > }
 > 
 > This kernel boots up OK. Looking at the preprocessed C code the 
 > following code in alternative_instructions() is compiled in:
 > 
 > #ifdef CONFIG_SMP
 > 	if (smp_alt_once) {
 > 		if (1 == num_possible_cpus()) {
 > 			printk(KERN_INFO "SMP alternatives: switching to UP code\n");
 > ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ This I still see at bootup
 > 
 > 			set_bit(X86_FEATURE_UP, boot_cpu_data.x86_capability);
 > 			set_bit(X86_FEATURE_UP, cpu_data[0].x86_capability);
 > 			alternatives_smp_unlock(__smp_locks, __smp_locks_end,
 > 						_text, _etext);
 > 
 > ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ this function uses text_poke()
 > ---> BOOM
 > 		}
 > 		free_init_pages("SMP alternatives",
 > 				(unsigned long)__smp_locks,
 > 				(unsigned long)__smp_locks_end);
 > 
 > So what can we do about the clflush on this CPU?

Could be that even though it advertises clflush support there are
errata on some revs of the CPU.  Can you paste your /proc/cpuinfo,
and I'll check with VIA to find out if they're aware of any
known problems and if so, find out the range of steppings we
need to not use clflush on.

	Dave

-- 
http://www.codemonkey.org.uk
