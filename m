Return-Path: <linux-kernel-owner+w=401wt.eu-S1758044AbZBKRPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044AbZBKRPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 12:15:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756757AbZBKROx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 12:14:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39016 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756457AbZBKROx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 12:14:53 -0500
Date: Wed, 11 Feb 2009 18:14:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86: more header untangling
Message-ID: <20090211171439.GA9185@elte.hu>
References: <4991D626.5040009@goop.org> <20090211100323.GE20518@elte.hu> <49930485.3070204@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49930485.3070204@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> The difference is this:
>>
>>  - page*.h is for page frame definitions and general
>>    address space layout details that derive from the page frame.
>>
>>  - pgtable*.h is the pagetable hw format and all things related to it.
>>   
>
> Right.
>
>> Sure, pgtable.h still has to inherit page.h (we cannot talk about a
>> page table without knowing about a page), but not the other way around.
>>
>> I.e. the practical difference is not to pgtable.h, but to page.h: we stop
>> polluting those places with pte_t/pteval_t/etc details that only need
>> page.h.
>>
>> I'm sure there will be .c code fallout from moving definitions like this,
>> but we'll fix those. The previous batch of changes from you stabilized
>> quickly (we needed only 3 build fixes), so this approach seems to scale
>> well so far.
>>
>> So please move those definitions to their logically consistent place and
>> dont worry about the build fallout.
>>   
>
> OK.
>
>> Another thing:
>>
>>   
>>> arch/x86/include/asm/page-defs.h       |  155 ++++++++++++++++++++++
>>> arch/x86/include/asm/page.h            |  146 +--------------------
>>> arch/x86/include/asm/page_32-defs.h    |   92 +++++++++++++
>>> arch/x86/include/asm/page_32.h         |   89 +------------
>>> arch/x86/include/asm/page_64-defs.h    |  105 +++++++++++++++
>>> arch/x86/include/asm/page_64.h         |  101 +--------------
>>> arch/x86/include/asm/paravirt.h        |    2 +-
>>> arch/x86/include/asm/pgtable-defs.h    |  227 +++++++++++++++++++++++++++++++
>>> arch/x86/include/asm/pgtable.h         |  228 +-------------------------------
>>> arch/x86/include/asm/pgtable_32-defs.h |   46 +++++++
>>> arch/x86/include/asm/pgtable_32.h      |   42 +------
>>> arch/x86/include/asm/pgtable_64-defs.h |   46 +++++++
>>> arch/x86/include/asm/pgtable_64.h      |   48 +-------
>>> 13 files changed, 688 insertions(+), 639 deletions(-)
>>>     
>>
>> The splitup looks good (sans the comment above), but could you please name
>> them page_types.h, pgtable_types.h, like we did it for other, cleaned up
>> headers like spinlock_types.h?
>>   
>
> I considered it, but I went with -defs because 1) there are the existing  
> -defs.h headers in this area, [...]

well, there's just 2 defs in this area, while there are 96 *types*.h headers in all 
of Linux. So we should just move pgtable-2level-defs.h and pgtable-3level-defs.h to 
the _types notation.

> [...] and 2) the define constants and small inlines as well as types.

constants can be considered data types too. Small inlines are borderlines,
they should generally not be in _types.h headers. Really, _types.h headers
are only there to instantiate a type, to enable dependent inline methods
to use them.

	Ingo
