Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901AbZEYQ24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbZEYQ24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 12:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbZEYQ2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 12:28:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:25848 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545AbZEYQ2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 12:28:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,245,1241420400"; 
   d="scan'208";a="460271387"
Message-ID: <4A1AC741.3060600@intel.com>
Date: Mon, 25 May 2009 09:28:49 -0700
From: "H. Peter Anvin" <h.peter.anvin@intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Brian Maly <bmaly@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dannf@hp.com" <dannf@hp.com>
Subject: Re: [PATCH] rtc: add x86 support for rtc-efi
References: <49DA40B9.2060804@redhat.com> <49DA817E.8040705@intel.com>	 <49DA8875.5050009@redhat.com>	 <20090409161803.f79c0b64.akpm@linux-foundation.org>	 <20090410135102.GB24809@elte.hu> <49ECADAB.4020609@redhat.com>	 <20090420172045.GA17887@elte.hu>  <49ECBD31.9010607@intel.com> <1243230547.31256.65.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1243230547.31256.65.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> On Tue, 2009-04-21 at 02:21 +0800, Anvin, H Peter wrote:
>> Ingo Molnar wrote:
>>> * Brian Maly <bmaly@redhat.com> wrote:
>>>
>>>>> Hm, it would be nice to first unify the relevant bits of 
>>>>> arch/x86/kernel/time_{32|64}.c into arch/x86/kernel/time.c, and 
>>>>> then we can apply such patches without duplicative effects.
>>>> Ingo,
>>>>
>>>> Are you OK with consolidating this into arch/x86/kernel/rtc.c as 
>>>> Huang Ying had suggested? This seems like the most logical place 
>>>> for the rtc-efi init to happen, but your suggestion to consolidate 
>>>> this into arch/x86/kernel.time.c may have advantages that I am not 
>>>> aware of.  Anyway, I would appreciate any insight/opinions on this 
>>>> if you have any.  Thanks.
>>> Yes, that indeed sounds like an even better place for it.
>>>
>> Furthermore, the EFI RTC code probably should be in its own file.
>>
>> In fact, arch/x86/kernel really could use more subdirectories; at least 
>> the EFI and UV-specific code should be be moved out.
> 
> Or, do you think it is appropriate to re-organize EFI related code into
> a sub-architecture?
> 

No, we're been trying to get rid of subarchitectures in the x86 kernel. 
  The reason is that the notion of subarchitectures matches reality in 
x86-land poorly.  Most variants of x86 share considerable code: UV has 
EFI, PC has EFI or BIOS, Voyager has BIOS and a standard RTC, and so on.

	-hpa

