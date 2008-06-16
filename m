Return-Path: <linux-kernel-owner+w=401wt.eu-S1760074AbYFPIB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760074AbYFPIB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 04:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbYFPIBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 04:01:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52105 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816AbYFPIBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 04:01:48 -0400
Date: Mon, 16 Jun 2008 10:01:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hpa@zytor.com,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] kernel parameter vmalloc size fix
Message-ID: <20080616080131.GC25632@elte.hu>
References: <20080616042528.GA3003@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080616042528.GA3003@darkstar.te-china.tietoenator.com>
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


* Dave Young <hidave.darkstar@gmail.com> wrote:

> booting kernel with vmalloc=[any size<=16m] will oops.
> 
> It's due to the vm area hole.
> 
> In include/asm-x86/pgtable_32.h:
> #define VMALLOC_OFFSET	(8 * 1024 * 1024)
> #define VMALLOC_START	(((unsigned long)high_memory + 2 * VMALLOC_OFFSET - 1) \
> 			 & ~(VMALLOC_OFFSET - 1))
> 
> BUG_ON in arch/x86/mm/init_32.c will be triggered:
> BUG_ON((unsigned long)high_memory		> VMALLOC_START);
> 
> Fixed by return -EINVAL for invalid parameter

hm. Why dont we instead add the size of the hole to the 
__VMALLOC_RESERVE value instead? There's nothing inherently bad about 
using vmalloc=16m. The VM area hole is really a kernel-internal 
abstraction that should not be visible in the usage of the parameter.

	Ingo
