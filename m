Return-Path: <linux-kernel-owner+w=401wt.eu-S1757893AbZBKRCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893AbZBKRCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 12:02:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407AbZBKRCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 12:02:01 -0500
Received: from gw.goop.org ([64.81.55.164]:41861 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755329AbZBKRCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 12:02:00 -0500
Message-ID: <49930485.3070204@goop.org>
Date: Wed, 11 Feb 2009 09:01:57 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86: more header untangling
References: <4991D626.5040009@goop.org> <20090211100323.GE20518@elte.hu>
In-Reply-To: <20090211100323.GE20518@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> The difference is this:
>
>  - page*.h is for page frame definitions and general
>    address space layout details that derive from the page frame.
>
>  - pgtable*.h is the pagetable hw format and all things related to it.
>   

Right.

> Sure, pgtable.h still has to inherit page.h (we cannot talk about a
> page table without knowing about a page), but not the other way around.
>
> I.e. the practical difference is not to pgtable.h, but to page.h: we stop
> polluting those places with pte_t/pteval_t/etc details that only need
> page.h.
>
> I'm sure there will be .c code fallout from moving definitions like this,
> but we'll fix those. The previous batch of changes from you stabilized
> quickly (we needed only 3 build fixes), so this approach seems to scale
> well so far.
>
> So please move those definitions to their logically consistent place and
> dont worry about the build fallout.
>   

OK.

> Another thing:
>
>   
>> arch/x86/include/asm/page-defs.h       |  155 ++++++++++++++++++++++
>> arch/x86/include/asm/page.h            |  146 +--------------------
>> arch/x86/include/asm/page_32-defs.h    |   92 +++++++++++++
>> arch/x86/include/asm/page_32.h         |   89 +------------
>> arch/x86/include/asm/page_64-defs.h    |  105 +++++++++++++++
>> arch/x86/include/asm/page_64.h         |  101 +--------------
>> arch/x86/include/asm/paravirt.h        |    2 +-
>> arch/x86/include/asm/pgtable-defs.h    |  227 +++++++++++++++++++++++++++++++
>> arch/x86/include/asm/pgtable.h         |  228 +-------------------------------
>> arch/x86/include/asm/pgtable_32-defs.h |   46 +++++++
>> arch/x86/include/asm/pgtable_32.h      |   42 +------
>> arch/x86/include/asm/pgtable_64-defs.h |   46 +++++++
>> arch/x86/include/asm/pgtable_64.h      |   48 +-------
>> 13 files changed, 688 insertions(+), 639 deletions(-)
>>     
>
> The splitup looks good (sans the comment above), but could you please name
> them page_types.h, pgtable_types.h, like we did it for other, cleaned up
> headers like spinlock_types.h?
>   

I considered it, but I went with -defs because 1) there are the existing 
-defs.h headers in this area, and 2) the define constants and small 
inlines as well as types.

    J
