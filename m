Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbYIKIRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbYIKIRl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 04:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbYIKIRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 04:17:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40907 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbYIKIRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 04:17:23 -0400
Date: Thu, 11 Sep 2008 10:17:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Dave Airlie <airlied@gmail.com>, "Li, Shaohua" <shaohua.li@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@codemonkey.org.uk>
Subject: Re: AGP PAT issue.
Message-ID: <20080911081702.GA27425@elte.hu>
References: <20080820194127.GA10887@linux-os.sc.intel.com> <48AC8F69.4050201@keyaccess.nl> <21d7e9970808201446k3c1a6bc1naf04568a8ad06ed4@mail.gmail.com> <20080820221630.GA3598@linux-os.sc.intel.com> <20080821120626.GG5615@elte.hu> <48ADA2C2.8090905@keyaccess.nl> <48ADF3FC.7070002@keyaccess.nl> <20080822041544.GF30284@elte.hu> <48AF1B6A.80408@keyaccess.nl> <48C8259B.7040702@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C8259B.7040702@keyaccess.nl>
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


* Rene Herman <rene.herman@keyaccess.nl> wrote:

> On 22-08-08 22:02, Rene Herman wrote:
>
>> On 22-08-08 06:15, Ingo Molnar wrote:
>
>>> The frontside cache itself is in x86/urgent:
>>>
>>>  # 80c5e73: x86: fix Xorg startup/shutdown slowdown with PAT
>>>
>>> ... and should at least solve the symptom that you've hit in practice 
>>> (the slowdown), without changing the underlying PAT machinery. (which 
>>> would be way too dangerous for v2.6.27)
>>
>> Well, please note that that specific commit only fixes X startup -- it  
>> doesn't do anything for shutdown. With only that one, I'm still at 14  
>> seconds for X shutdown (first time after boot that is, 5 seconds  
>> subsequent shutdowns) versus 1 (or sub 1, feels immediate) normally.
>>
>> It's also a black-screen "hang", so we'll probably be getting a lot of  
>> "long hang at shutdown" reports without something additionally for .27.
>>
>> Venki?
>
> Haven't been subcribed to any lists recently and someone was talking 
> about "the other thread" before but just noticed that an -rc6 was cut.
>
> Please note that the shutdown issue remains unfixed in it (I'm doing 
> my coalescing changes locally).

here's what is pending in tip/x86/pat for v2.6.28:

110e035: x86: make sure the CPA test code's use of _PAGE_UNUSED1 is obvious
c09ff7e: linux-next: fix x86 tree build failure
01de05a: x86: have set_memory_array_{uc,wb} coalesce memtypes, fix
5f310b6: agp: enable optimized agp_alloc_pages methods
c5e147c: x86: have set_memory_array_{uc,wb} coalesce memtypes.
9a79f4f: x86: {reverve,free}_memtype() take a physical address
8b53b57: Merge branch 'x86/urgent' into x86/pat
ab7e792: x86: fix pageattr-test
bd07928: agp: add agp_generic_destroy_pages()
37acee1: agp: generic_alloc_pages()
d75586a: x86, pageattr: introduce APIs to change pageattr of a page array
cacf890: Revert "introduce two APIs for page attribute"
9326d61: Revert "reduce tlb/cache flush times of agpgart memory allocation"
5843d9a: x86, pat: avoid highmem cache attribute aliasing
466ae83: reduce tlb/cache flush times of agpgart memory allocation
1ac2f7d: introduce two APIs for page attribute
012f09e: x86: compile pat debugfs interface only if CONFIG_X86_PAT is set

that includes your coalescing optimizations and fixes. None of that is 
really v2.6.27 material i think.

Btw., if you track -tip as per:

  http://people.redhat.com/mingo/tip.git/README

you can merge these changes alone into latest -git just by doing:

  git merge tip/x86/pat

or you can use tip/master for the full range of pending features and 
fixes.

	Ingo
