Return-Path: <linux-kernel-owner+w=401wt.eu-S1755268AbYJXJiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbYJXJiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 05:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbYJXJhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 05:37:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47011 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbYJXJhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 05:37:51 -0400
Date: Fri, 24 Oct 2008 11:32:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas@tungstengraphics.com>
Cc: Keith Packard <keithp@keithp.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, nickpiggin@yahoo.com.au,
       airlied@linux.ie, dri-devel@lists.sf.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, Peter Anvin <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, yinghai@kernel.org
Subject: Re: Adding kmap_atomic_prot_pfn
Message-ID: <20081024093233.GA20310@elte.hu>
References: <20081022093615.GF12453@elte.hu> <1224793332.22877.8.camel@koto.keithp.com> <20081023133840.d4eef579.akpm@linux-foundation.org> <alpine.LFD.2.00.0810231424220.3287@nehalem.linux-foundation.org> <1224813015.22877.51.camel@koto.keithp.com> <alpine.LFD.2.00.0810231934590.3287@nehalem.linux-foundation.org> <1224829359.22877.86.camel@koto.keithp.com> <49017A2C.5010504@tungstengraphics.com> <20081024083830.GB6734@elte.hu> <49019307.6070207@tungstengraphics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49019307.6070207@tungstengraphics.com>
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


* Thomas Hellström <thomas@tungstengraphics.com> wrote:

> Ingo Molnar wrote:
>> * Thomas Hellström <thomas@tungstengraphics.com> wrote:
>>
>>   
>>> Keith,
>>>
>>> What you actually are doing here is claiming copyright on code that  
>>> other people have written, and tighten the export restrictions.   
>>> kmap_atomic_prot_pfn() appeared long ago in drm git with identical  
>>> code and purpose, but with different authors, and iounmap_atomic is  
>>> identical to kunmap_atomic.
>>>     
>>
>>   
>>>> +EXPORT_SYMBOL_GPL(iomap_atomic_prot_pfn);
>>>>       
>>
>> you want to use this facility in a binary-only driver?
>>
>> 	Ingo
>>   
> At this point I have no such use for it, no.
> The original user was a MIT style licenced driver.

okay, then just to put this question to rest: i wrote the original 
32-bit highmem code ~10 years ago. I wrote the first version of fixmap 
support - in fact i coined the term. I wrote the first version of the 
atomic-kmap facility as well.

All of that code is licensed under the GPLv2. So if anyone wants to make 
any copyright claims about highmem/kmap/fixmap derivative works, 
consider it in that light.

Regarding this new API variant that Keith wrote: it would be silly and 
dangerous to export it anywhere but to in-kernel drivers. The API 
disables preemption on 32-bit and rummages deep in the guts of the 
kernel as well, uses up a precious resource (fixmap slots), etc. It's 
internal and we eventually might want to deprecate forms of it and 
concentrate on the good 64-bit performance side.

	Ingo
