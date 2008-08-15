Return-Path: <linux-kernel-owner+w=401wt.eu-S1759307AbYHOOjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307AbYHOOjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 10:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbYHOOjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 10:39:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48441 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588AbYHOOjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 10:39:00 -0400
Date: Fri, 15 Aug 2008 16:38:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       michael@free-electrons.com
Subject: Re: [PATCH 1/1] [x86] Configuration options to compile out x86 CPU
	support code
Message-ID: <20080815143843.GA519@elte.hu>
References: <1217929519-10527-1-git-send-email-thomas.petazzoni@free-electrons.com> <20080815141855.GB12954@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080815141855.GB12954@elte.hu>
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


-tip testing found a couple of build failures:

  LD      .tmp_vmlinux1
arch/x86/lib/lib.a(usercopy_32.o): In function `__copy_to_user_ll':
(.text+0x11e): undefined reference to `movsl_mask'
arch/x86/lib/lib.a(usercopy_32.o): In function `__copy_from_user_ll':
(.text+0x1fa): undefined reference to `movsl_mask'
arch/x86/lib/lib.a(usercopy_32.o): In function 
`__copy_from_user_ll_nozero':
(.text+0x2d6): undefined reference to `movsl_mask'
arch/x86/lib/lib.a(usercopy_32.o): In function `copy_from_user':
(.text+0x5ac): undefined reference to `movsl_mask'
arch/x86/lib/lib.a(usercopy_32.o): In function `copy_to_user':
(.text+0x6bf): undefined reference to `movsl_mask'
make: *** [.tmp_vmlinux1] Error 1

with:

  http://redhat.com/~mingo/misc/config-Fri_Aug_15_16_35_03_CEST_2008.bad

and:

arch/x86/kvm/built-in.o: In function `paging64_cmpxchg_gpte':
mmu.c:(.text+0xa80d): undefined reference to `cmpxchg_486_u64'

with:

  http://redhat.com/~mingo/misc/config-Fri_Aug_15_16_27_47_CEST_2008.bad

reverting your change solved both of them.

i still have the commit in tip/x86/cpu so please send a delta fix ontop 
of your previous patch once you figure out the problem. Thanks,

	Ingo
