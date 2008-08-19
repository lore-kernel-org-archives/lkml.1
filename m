Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbYHSFjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbYHSFjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 01:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbYHSFiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 01:38:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:26119 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574AbYHSFiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 01:38:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,233,1217833200"; 
   d="scan'208";a="371764082"
Subject: Re: [PATH -mm] Fix a race condtion of oops_in_progress
From: Huang Ying <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080818210657.c7f3cd87.akpm@linux-foundation.org>
References: <1219025007.5663.22.camel@yhuang-dev.sh.intel.com>
	 <20080818210657.c7f3cd87.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 19 Aug 2008 13:38:00 +0800
Message-Id: <1219124280.5663.88.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-18 at 21:06 -0700, Andrew Morton wrote:
> On Mon, 18 Aug 2008 10:03:27 +0800 Huang Ying <ying.huang@intel.com> wrote:
> 
> > This patch fix a race condition of oops_in_progress. Which may be
> > changed on multiple CPU simultaneously, but it is changed via
> > non-atomic operation ++/--. This patch changes the definition of
> > oops_in_process from int to atomic_t, and accessing method to atomic
> > operations.
> 
> 
> > extern atomic_t oops_in_progress;
> 
> In file included from include/asm/system.h:10,
>                  from include/asm/processor.h:17,
>                  from include/asm/atomic_32.h:5,
>                  from include/asm/atomic.h:2,
>                  from include/linux/crypto.h:20,
>                  from arch/x86/kernel/asm-offsets_32.c:7,
>                  from arch/x86/kernel/asm-offsets.c:2:
> include/linux/kernel.h:236: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'oops_in_progress'
> make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
> make: *** [prepare0] Error 2
> 
> we can't inlude asm/atomic.h from linux/kernel.h because asm/atomic.h
> includes linux/kernel.h via the above route.
> 
> And we cannot forward-declare atomic_t by hand because it's a typedef.
> 
> Not sure what to do, really.  Find a different header file in which to
> declare oops_in_progress?

It seems that asm/atomic.h is used for both atomic_t declaration and
implementation, how about separate them? That it, add a new file
asm/atomic_def.h, put typedef there, and include asm/atomic_def.h in
kernel.h?

Best Regards,
Huang Ying


