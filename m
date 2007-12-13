Return-Path: <linux-kernel-owner+w=401wt.eu-S932420AbXLMU7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420AbXLMU7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 15:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761016AbXLMU7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 15:59:14 -0500
Received: from gw.goop.org ([64.81.55.164]:48285 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762124AbXLMU7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 15:59:13 -0500
Message-ID: <47619D0D.4010909@goop.org>
Date: Thu, 13 Dec 2007 12:58:53 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 1/3] x86: clean up asm-x86/page*.h
References: <476030CE.4050203@goop.org> <20071213102110.GP8977@elte.hu>
In-Reply-To: <20071213102110.GP8977@elte.hu>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Unify common definitions in page*.h.  To simplify other code, I added 
>> typedefs for the value of pte/pmd/pud/pgd values, so they can be used 
>> symbolically elsewhere without needing to have lots of 32/64/PAE 
>> tests.
>>
>> Also, add PAGETABLE_LEVELS define so that other definitions can test 
>> for it directly rather than using indirect 32/64/PAE tests.
>>
>> Signed-off-by: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
>>     
>
> hm, your patches dont build. This is the error i get:
>
>  include/asm-generic/pgtable-nopmd.h:46:1: warning: this is the location of the previous definition
>  In file included from include/asm/pgtable_32.h:86,
>                  from include/asm/pgtable.h:131,
>                  from include/linux/mm.h:39,
>                  from include/linux/suspend.h:12,
>                  from arch/x86/kernel/asm-offsets_32.c:12,
>                  from arch/x86/kernel/asm-offsets.c:3:
>  include/asm/pgtable-2level.h:55: error: redefinition of 'native_pte_clear'
>  include/asm/pgtable-2level.h:43: error: previous definition of 'native_pte_clear' was here
>   

I can't reproduce that specific compile error, but I found & fixed a
couple of problems with your config.

BTW, I'm having a workflow problem using git to fetch your tree.  When I do:

    $ git-pull git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git mm
    remote: Generating pack...
    remote: Done counting 3454 objects.
    Result has 2947 objects.
    remote: Deltifying 2947 objects...
    remote:  100% (2947/2947) done
    Indexing 2947 objects...
    remote: Total 2947 (delta 2559), reused 2432 (delta 2066)
     100% (2947/2947) done
    Resolving 2559 deltas...
     100% (2559/2559) done
    458 objects were added to complete this thin pack.
    Renamed arch/x86/crypto/twofish_64.c->arch/x86/crypto/twofish.c
    Auto-merged arch/x86/crypto/twofish.c
    Renamed arch/x86/ia32/vsyscall-syscall.S->arch/x86/vdso/vdso32/syscall.S
    Auto-merged arch/x86/vdso/vdso32/syscall.S
    Renamed arch/x86/kernel/ldt_32.c->arch/x86/kernel/ldt.c
    Auto-merged arch/x86/kernel/ldt.c
    CONFLICT (content): merge conflict in arch/x86/kernel/ldt.c
    Renamed arch/x86/kernel/sysenter_32.c->arch/x86/vdso/vdso32-setup.c
    Auto-merged arch/x86/vdso/vdso32-setup.c
    Renamed arch/x86/kernel/vsyscall-int80_32.S->arch/x86/vdso/vdso32/int80.S
    Auto-merged arch/x86/vdso/vdso32/int80.S
    ...
      

I haven't made any local changes and I don't want to merge anything - I
just want to get an up to date copy of your tree.  What am I missing
here?  I end up having to ssh into master.kernel.org, look at
linux-2.6-x86.git/refs/heads/mm and then do "git reset --hard XXX" from
that, which doesn't seem like the right answer...

Thanks,
    J
