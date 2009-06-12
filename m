Return-Path: <linux-kernel-owner+w=401wt.eu-S1764255AbZFLQJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764255AbZFLQJ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763495AbZFLQJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:09:01 -0400
Received: from claw.goop.org ([74.207.240.146]:38600 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763041AbZFLQJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:09:00 -0400
Message-ID: <4A327D94.8010902@goop.org>
Date: Fri, 12 Jun 2009 09:08:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] x86/paravirt: clean up paravirt.h and optimise FPU
 context switch
References: <1244748040-27185-1-git-send-email-jeremy@goop.org> <20090612123753.GG31845@elte.hu>
In-Reply-To: <20090612123753.GG31845@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/09 05:37, Ingo Molnar wrote:
> * Jeremy Fitzhardinge<jeremy@goop.org>  wrote:
>
>    
>> Hi Ingo,
>>
>> This series:
>>   - splits asm/paravirt.h into paravirt.h and paravirt_types.h
>>   - splits out the context switch core of math_state_restore into __math_state_restore
>>   - rearranges 32 and 64 bit context switch to be the same and to properly
>>     batch FPU context switches when running paravirtualized
>>
>> There should be no performance side-effects of these changes.  They amount
>> to a small rearrangement of the existing code (and bringing the 64-bit
>> code a bit closer to 32-bit, countering some genetic drift).
>>
>> I think these are probably safe to go into this merge window, but I
>> don't think I've posted these before, so I understand if you're hesitant
>> (I've had them applied locally for some time with no ill-effects).
>> The paravirt cleanup is pure movement between headers, so I don't think
>> there's much risk there at all.
>>
>>   arch/x86/include/asm/i387.h           |    1 +
>>   arch/x86/include/asm/paravirt.h       |  711 +--------------------------------
>>   arch/x86/include/asm/paravirt_types.h |  720 +++++++++++++++++++++++++++++++++
>>   arch/x86/kernel/process_32.c          |   27 +-
>>   arch/x86/kernel/process_64.c          |   33 +-
>>   arch/x86/kernel/traps.c               |   33 +-
>>   6 files changed, 782 insertions(+), 743 deletions(-)
>>      
>
> hm, no Git pull coordinates - but you have this in a Git tree,
> right?
>    

Oh, yep:


The following changes since commit 588aa5f175154e2b15565fda4c21741c1c1d25a8:
   Ingo Molnar (1):
         Merge branch 'kmemcheck'

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git x86/paravirt

Jeremy Fitzhardinge (5):
       x86/paravirt: split paravirt definitions into paravirt_types.h
       x86: split out core __math_state_restore
       x86-32: make sure clts is batched during context switch
       x86-64: move unlazy_fpu() into lazy cpu state part of context switch
       x86-64: move clts into batch cpu state updates when preloading fpu

  arch/x86/include/asm/i387.h           |    1 +
  arch/x86/include/asm/paravirt.h       |  711 +--------------------------------
  arch/x86/include/asm/paravirt_types.h |  720 +++++++++++++++++++++++++++++++++
  arch/x86/kernel/process_32.c          |   27 +-
  arch/x86/kernel/process_64.c          |   33 +-
  arch/x86/kernel/traps.c               |   33 +-
  6 files changed, 782 insertions(+), 743 deletions(-)
  create mode 100644 arch/x86/include/asm/paravirt_types.h

	J

