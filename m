Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbZIBX1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbZIBX1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 19:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753802AbZIBX1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 19:27:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:12649 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684AbZIBX1Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 19:27:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,321,1249282800"; 
   d="scan'208";a="489987395"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Luming Yu <luming.yu@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "Yu, Fenghua" <fenghua.yu@intel.com>, Felix Blyakher <felixb@sgi.com>,
       "Li, Shaohua" <shaohua.li@intel.com>, Bob Picco <bob.picco@hp.com>
Date: Wed, 2 Sep 2009 16:27:15 -0700
Subject: RE: [RFC PATCH] Add TRACE_IRQFLAGS_SUPPORT, LOCKDEP_SUPPORT then
	enable ftrace for ia64
Thread-Topic: [RFC PATCH] Add TRACE_IRQFLAGS_SUPPORT, LOCKDEP_SUPPORT then
	enable ftrace for ia64
Thread-Index: Aconp+zyRL0CHhFBTlCYopqLjHCCCAEfEDQg
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3E038DE7E@orsmsx505.amr.corp.intel.com>
References: <3877989d0908272018va6ee8f7n7ab2838fdf1b26e6@mail.gmail.com>
 <20090828062212.GB11552@elte.hu>
In-Reply-To: <20090828062212.GB11552@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> diff -BruN linux-2.6.31-rc6/arch/ia64/include/asm/page.h
>> linux-2.6.31-rc6-lockdep/arch/ia64/include/asm/page.h
>> --- linux-2.6.31-rc6/arch/ia64/include/asm/page.h	2009-08-13
>> 15:43:34.000000000 -0700
>> +++ linux-2.6.31-rc6-lockdep/arch/ia64/include/asm/page.h	2009-08-23
>> 18:59:00.000000000 -0700
>> @@ -41,7 +41,7 @@
>>  #define PAGE_SIZE		(__IA64_UL_CONST(1) << PAGE_SHIFT)
>>  #define PAGE_MASK		(~(PAGE_SIZE - 1))
>> 
>> -#define PERCPU_PAGE_SHIFT	16	/* log2() of max. size of per-CPU area */
>> +#define PERCPU_PAGE_SHIFT	20	/*16 log2() of max. size of per-CPU area */
>>  #define PERCPU_PAGE_SIZE	(__IA64_UL_CONST(1) << PERCPU_PAGE_SHIFT)
>
> Why was this seemingly unrelated change done in a lockdep patch?

IIRC it is because the lockdep code needs a lot more percpu memory than the
64K that ia64 allocates.

But I think that I'd prefer to only allocate the extra space when it
is needed:

#ifdef CONFIG_LOCKDEP
#define PERCPU_PAGE_SHIFT 20 /* Need a Megabyte for lockdep */
#else
#define PERCPU_PAGE_SHIFT 16 /* 64K should be enough for normal use */
#endif

-Tony


