Return-Path: <linux-kernel-owner+w=401wt.eu-S1753771AbYJFFAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbYJFFAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 01:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbYJFFAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 01:00:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38263 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbYJFFAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 01:00:40 -0400
Date: Mon, 6 Oct 2008 07:00:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Huang Ying <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH -mm -v3] Separate atomic_t declaration from
	asm/atomic.h into asm/atomic_def.h
Message-ID: <20081006050022.GA2186@elte.hu>
References: <1223263964.5872.20.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223263964.5872.20.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Huang Ying <ying.huang@intel.com> wrote:

> From: Huang Ying <ying.huang@intel.com>
> 
> asm/atomic.h contains both declaration and implementation of atomic_t.  So
> there are some implementation related files included in asm/atomic.h.  And
> atomic_t is a typedef.  Combination of above makes it impossible to use
> atomic_t in files included by atomic.h.  Such as atomic_t can not be used
> in linux/kernel.h on i386, because it is included by asm/atomic.h.
> 
> It is reasonable to separate declaration from implementation.  So a new
> file atomic_def.h is added for every architecture to accommodate the
> declaration of atomic_t.
> 
> Includes fixes from Andrew Moton.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> ---
> 
>  include/asm-x86/atomic_32.h             |   10 +---------
>  include/asm-x86/atomic_64.h             |   10 +---------
>  include/asm-x86/atomic_def.h            |   13 +++++++++++++

nice cleanup!

One small request: could you please use the standard naming convention 
please and rename it to atomic_types.h?

That moves it in line with existing data type files: kvm_types.h, 
mm_types.h, posix_types.h, spinlock_types.h, amd_iommu_types.h, 
kmap_types.h, etc.

Easiest is to do it via:

 sed -i 's/atomic_def.h/atomic_types.h/g' patches/separate-atomic.patch

Reviewed-by: Ingo Molnar <mingo@elte.hu>

Thanks,

	Ingo
