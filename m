Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbYCUMDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbYCUMDf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 08:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbYCUMDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 08:03:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35867 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308AbYCUMDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 08:03:24 -0400
Date: Fri, 21 Mar 2008 13:03:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: yhlu.kernel@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: early memtest to find bad ram
Message-ID: <20080321120313.GD25225@elte.hu>
References: <200803202358.33722.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803202358.33722.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:

> do simple memtest after init_memory_mapping
> 
> use find_e820_area_size to find all ram range that is not reserved.
> 
> and do some simple bits test to find some bad ram.
> 
> if find some bad ram, use reserve_early to exclude that range.

very nice patch! I always thought that this was the proper way to do 
memtest - and we could in fact also do something like this after SMP 
bringup, and hit the memory bus via multiple CPUs. [that will need a 
different enumeration though than e820 maps]

one structural observation: please make this unified functionality, so 
that 32-bit kernels can make use of it too.

a small style nit from scripts/checkpatch.pl:

> +//		printk(KERN_DEBUG "find_e820_area_size : e820 %d [%llx, %lx]\n", i, ei->addr, ei_last);

remove such lines or make them pr_debug(). (checkpatch also found more 
such cases)

also, please add a CONFIG_BOOTPARAM_MEMTEST=y option so that 
distributions can enable this by default in their debug kernels.

i've applied your current version to get some testing, please send delta 
patches against x86/latest.

	Ingo
