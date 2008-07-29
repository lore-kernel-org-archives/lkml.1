Return-Path: <linux-kernel-owner+w=401wt.eu-S1754475AbYG2Ayb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbYG2Ayb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 20:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbYG2AyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 20:54:24 -0400
Received: from saeurebad.de ([85.214.36.134]:54450 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408AbYG2AyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 20:54:23 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linuxfoundation.org,
       torvalds@linuxfoundation.org, npiggin@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: do not overrun page table ranges in gup
References: <20080728184947.GA5041@martell.zuzino.mipt.ru>
	<20080728185316.GA19479@martell.zuzino.mipt.ru>
	<87y73l5zlj.fsf_-_@saeurebad.de> <87tze95yrk.fsf@saeurebad.de>
	<alpine.LFD.1.10.0807281721200.3486@nehalem.linux-foundation.org>
Date: Tue, 29 Jul 2008 02:53:58 +0200
In-Reply-To: <alpine.LFD.1.10.0807281721200.3486@nehalem.linux-foundation.org>
	(Linus Torvalds's message of "Mon, 28 Jul 2008 17:33:46 -0700 (PDT)")
Message-ID: <87prox5x3t.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Tue, 29 Jul 2008, Johannes Weiner wrote:
>> 
>> Actually, I think the prettier fix would be to just establish that
>> garuantee:
>>
>> --- a/arch/x86/mm/gup.c
>> +++ b/arch/x86/mm/gup.c
>> @@ -223,7 +223,7 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
>>  			struct page **pages)
>>  {
>>  	struct mm_struct *mm = current->mm;
>> -	unsigned long end = start + (nr_pages << PAGE_SHIFT);
>> +	unsigned long end = PAGE_ALIGN(start + (nr_pages << PAGE_SHIFT));
>
> Umm. 'end' is guaranteed to be page-aligned if 'start' is. 
>
> So if this makes a difference, that implies that _start_ isn't 
> page-aligned, and then you when you add PAGE_SIZE to 'addr', you are going 
> to miss 'end' again.
>
> So no, the right fix would be to align 'start' first, which means that 
> everything else (including 'end') will be page-aligned. Aligning just one 
> or the other is very very wrong.

Blah, I just should call it a day.  Thanks for the explanation, you are
right.

	Hannes
