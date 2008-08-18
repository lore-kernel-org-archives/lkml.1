Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbYHRGTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbYHRGTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 02:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbYHRGTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 02:19:45 -0400
Received: from mga14.intel.com ([143.182.124.37]:15763 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbYHRGTo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 02:19:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,226,1217833200"; 
   d="scan'208";a="34681254"
From: "Li, Shaohua" <shaohua.li@intel.com>
To: Arjan van de Ven <arjan@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       "airlied@linux.ie" <airlied@linux.ie>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 18 Aug 2008 14:19:36 +0800
Subject: RE: [patch 2/2] reduce tlb/cache flush times of agpgart memory
 allocation
Thread-Topic: [patch 2/2] reduce tlb/cache flush times of agpgart memory
 allocation
Thread-Index: AckA5oJ7+j36fGvhSWKpoj8bUfEF1QAE6KnQ
Message-ID: <76780B19A496DC4B80439008DAD7076C0CF9E403@PDSMSX501.ccr.corp.intel.com>
References: <1217832690.21811.9.camel@sli10-desk.sh.intel.com>
	<20080815143131.GF12954@elte.hu>	<20080815074033.4817f876@infradead.org>
	<76780B19A496DC4B80439008DAD7076C0CF9E0E1@PDSMSX501.ccr.corp.intel.com>
 <20080817205643.25deb89d@infradead.org>
In-Reply-To: <20080817205643.25deb89d@infradead.org>
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



>-----Original Message-----
>From: Arjan van de Ven [mailto:arjan@infradead.org]
>Sent: Monday, August 18, 2008 11:57 AM
>To: Li, Shaohua
>Cc: Ingo Molnar; lkml; airlied@linux.ie; Andrew Morton; Ingo Molnar; Siddha,
>Suresh B; Pallipadi, Venkatesh; Thomas Gleixner; H. Peter Anvin
>Subject: Re: [patch 2/2] reduce tlb/cache flush times of agpgart memory
>allocation
>
>On Mon, 18 Aug 2008 09:21:12 +0800
>"Li, Shaohua" <shaohua.li@intel.com> wrote:
>
>>
>> >
>> >it really needs something else instead; it needs airlied's array
>> >allocator
>> >otherwise you hit the second wall as well (the pat checks per page)
>> Somebody should have a measurement. In my test, the real bottleneck
>> is the cache flush. It appears flush cache page is slow if there are
>> a lot of pages, In my patch, I use a wbinvd. This can be optimized to
>> do wbinvd with a threshold. Maybe airlied can change his patch with
>> this way.
>
>
>it would be great if you had time to update his patch and this to
>it...
I'll do it soon.

>and the logic probably should be "if there's more than X pags in the
>the array, just use wbinvd".
>Although wbinvd is very painful if you have 12Mb of cache and you wipe
>it for all cores in the system ;-(
This might not be that bad, changing attribute isn't frequently used.

Thanks,
Shaohua
