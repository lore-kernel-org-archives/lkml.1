Return-Path: <linux-kernel-owner+w=401wt.eu-S1754996AbYHRR0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbYHRR0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 13:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbYHRR0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 13:26:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46410 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbYHRR0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 13:26:42 -0400
Message-ID: <48A9AEE9.1060201@zytor.com>
Date: Mon, 18 Aug 2008 10:18:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Li, Shaohua" <shaohua.li@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "airlied@linux.ie" <airlied@linux.ie>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 2/2] reduce tlb/cache flush times of agpgart memory	allocation
References: <1217832690.21811.9.camel@sli10-desk.sh.intel.com> <20080815143131.GF12954@elte.hu> <20080815074033.4817f876@infradead.org> <76780B19A496DC4B80439008DAD7076C0CF9E0E1@PDSMSX501.ccr.corp.intel.com> <20080817205643.25deb89d@infradead.org> <76780B19A496DC4B80439008DAD7076C0CF9E403@PDSMSX501.ccr.corp.intel.com> <20080818080344.GK30694@elte.hu>
In-Reply-To: <20080818080344.GK30694@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Li, Shaohua <shaohua.li@intel.com> wrote:
> 
>>> it would be great if you had time to update his patch and this to 
>>> it...
>> I'll do it soon.
> 
> great! Please do it as a delta patch against tip/master:
> 
>    http://people.redhat.com/mingo/tip.git/README
> 
> as your first two patches are being tested already:
> 
>  466ae83: reduce tlb/cache flush times of agpgart memory allocation
>  1ac2f7d: introduce two APIs for page attribute
> 
> [ but it can all only go upstream once the observations from Arjan have
>   been addressed. ]
> 
>>> and the logic probably should be "if there's more than X pags in the 
>>> the array, just use wbinvd". Although wbinvd is very painful if you 
>>> have 12Mb of cache and you wipe it for all cores in the system ;-(
>> This might not be that bad, changing attribute isn't frequently used.
> 
> dont some X/DRM drivers do it for a wide range of GX ops?
> 

I think so... at least it's likely to become more common. 
Realistically, it means WBINVD, being uninterruptible, is probably 
unsafe even for very large amounts.

	-hpa
