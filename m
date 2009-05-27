Return-Path: <linux-kernel-owner+w=401wt.eu-S1760341AbZE0XWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760341AbZE0XWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 19:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758675AbZE0XWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 19:22:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57957 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756967AbZE0XWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 19:22:20 -0400
Date: Thu, 28 May 2009 01:21:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <h.peter.anvin@intel.com>
Cc: "Huang, Ying" <ying.huang@intel.com>, Brian Maly <bmaly@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dannf@hp.com" <dannf@hp.com>
Subject: Re: [PATCH] rtc: add x86 support for rtc-efi
Message-ID: <20090527232149.GA3830@elte.hu>
References: <49DA40B9.2060804@redhat.com> <49DA817E.8040705@intel.com> <49DA8875.5050009@redhat.com> <20090409161803.f79c0b64.akpm@linux-foundation.org> <20090410135102.GB24809@elte.hu> <49ECADAB.4020609@redhat.com> <20090420172045.GA17887@elte.hu> <49ECBD31.9010607@intel.com> <1243230547.31256.65.camel@yhuang-dev.sh.intel.com> <4A1AC741.3060600@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1AC741.3060600@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* H. Peter Anvin <h.peter.anvin@intel.com> wrote:

> Huang, Ying wrote:
>> On Tue, 2009-04-21 at 02:21 +0800, Anvin, H Peter wrote:
>>> Ingo Molnar wrote:
>>>> * Brian Maly <bmaly@redhat.com> wrote:
>>>>
>>>>>> Hm, it would be nice to first unify the relevant bits of  
>>>>>> arch/x86/kernel/time_{32|64}.c into arch/x86/kernel/time.c, and 
>>>>>> then we can apply such patches without duplicative effects.
>>>>> Ingo,
>>>>>
>>>>> Are you OK with consolidating this into arch/x86/kernel/rtc.c as  
>>>>> Huang Ying had suggested? This seems like the most logical place  
>>>>> for the rtc-efi init to happen, but your suggestion to 
>>>>> consolidate this into arch/x86/kernel.time.c may have advantages 
>>>>> that I am not aware of.  Anyway, I would appreciate any 
>>>>> insight/opinions on this if you have any.  Thanks.
>>>> Yes, that indeed sounds like an even better place for it.
>>>>
>>> Furthermore, the EFI RTC code probably should be in its own file.
>>>
>>> In fact, arch/x86/kernel really could use more subdirectories; at 
>>> least the EFI and UV-specific code should be be moved out.
>>
>> Or, do you think it is appropriate to re-organize EFI related code into
>> a sub-architecture?
>>
>
> No, we're been trying to get rid of subarchitectures in the x86 
> kernel.  The reason is that the notion of subarchitectures matches 
> reality in x86-land poorly.  Most variants of x86 share 
> considerable code: UV has EFI, PC has EFI or BIOS, Voyager has 
> BIOS and a standard RTC, and so on.

Yeah - we essentially got rid of the ex subarchitecture code in 
2.6.30. We still have config options that turn on various sorts of 
behavior - but most of them are runtime. We definitely dont want to 
reintroduce anything subarchitecture-ish.

	Ingo
