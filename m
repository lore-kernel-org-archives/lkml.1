Return-Path: <linux-kernel-owner+w=401wt.eu-S1754006AbYGVPXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbYGVPXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 11:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061AbYGVPXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 11:23:33 -0400
Received: from saeurebad.de ([85.214.36.134]:51039 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbYGVPXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 11:23:32 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] x86 fixes
References: <20080722140348.GA26267@elte.hu> <87prp6j8bh.fsf@saeurebad.de>
	<4885F7EF.7080803@goop.org>
Date: Tue, 22 Jul 2008 17:23:06 +0200
In-Reply-To: <4885F7EF.7080803@goop.org> (Jeremy Fitzhardinge's message of
	"Tue, 22 Jul 2008 08:08:31 -0700")
Message-ID: <871w1mj63p.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Johannes Weiner wrote:
>> Hi,
>>
>> Ingo Molnar <mingo@elte.hu> writes:
>>
>>   
>>> Linus,
>>>
>>> Please pull the latest x86 fixes git tree from:
>>>
>>>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus
>>>
>>> Thanks,
>>>
>>> 	Ingo
>>>
>>> ------------------>
>>> Jan Kratochvil (1):
>>>       x86: fix crash due to missing debugctlmsr on AMD K6-3
>>>
>>> Jeremy Fitzhardinge (2):
>>>       x86: rename PTE_MASK to PTE_PFN_MASK
>>>       x86: add PTE_FLAGS_MASK
>>>     
>>
>> Are you serious?  It goes _this_ fast?  The patch came into my mbox at
>> 8:00am this morning and you push it to Linus at 4:00pm already?
>>
>> What about the inconsistency it introduces?  When I look at PAGE_MASK
>> for example, it masks out the PAGE offset.  PTE_MASK masks out PTE
>> specifca from a value.
>>
>> Now, I assume PTE_PFN_MASK masks out the PFN.  Oh, wait, it masks the
>> protection bits.
>
> PAGE_MASK turns an address into its page address.
>
> PTE_PFN_MASK takes a pte value and returns the pte's pfn portion
> (which is shifted so it's actually a page address).

Okay, now it makes sense.

I just always thought of PAGE_MASK as `mask out sub-page granularity'.

> In both cases, the X_MASK terminology means that X is extracted, not
> excluded.  Which makes sense; if you have a packed bitfield containing
> multiple values, you wouldn't expect X to be the list of things *not*
> extracted.

Agreed.

	Hannes
