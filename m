Return-Path: <linux-kernel-owner+w=401wt.eu-S1755502AbYH0K7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbYH0K7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 06:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754513AbYH0K72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 06:59:28 -0400
Received: from mga05.intel.com ([192.55.52.89]:15351 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754059AbYH0K71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 06:59:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,278,1217833200"; 
   d="scan'208";a="374039165"
Message-ID: <48B53372.5060308@linux.intel.com>
Date: Wed, 27 Aug 2008 03:58:58 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Parag Warudkar <parag.lkml@gmail.com>, Adrian Bunk <bunk@stusta.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-embedded@vger.kernel.org
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>	<alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org>	<200808261111.19205.rusty@rustcorp.com.au>	<alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org>	<20080826183051.GB10925@cs181140183.pp.htv.fi>	<alpine.LFD.1.10.0808261144510.3363@nehalem.linux-foundation.org>	<20080826205916.GB11734@cs181140183.pp.htv.fi>	<alpine.LFD.1.10.0808261403360.3363@nehalem.linux-foundation.org>	<f7848160808261554j2f4eaaa6i1ee8801ae75ca7bf@mail.gmail.com>	<alpine.LFD.1.10.0808261644260.3363@nehalem.linux-foundation.org>	<f7848160808261758q7b84aab1m188c1ebb59304818@mail.gmail.com>	<alpine.LFD.1.10.0808261837530.3363@nehalem.linux-foundation.org> <18612.60878.887716.452936@drongo.ozlabs.ibm.com>
In-Reply-To: <18612.60878.887716.452936@drongo.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
> Linus Torvalds writes:
> 
>> 4kB used to be the _only_ choice. And no, there weren't even irq stacks. 
>> So that 4kB was not just the whole kernel call-chain, it was also all the 
>> irq nesting above it.
> 
> I think your memory is failing you.  In 2.4 and earlier, the kernel
> stack was 8kB minus the size of the task_struct, which sat at the
> start of the 8kB.  For instance, from include/asm-i386/processor.h for
> 2.4.29:

but was shared with interrupts; so out of the 6Kb left, you had still really only 4Kb for user context stack

