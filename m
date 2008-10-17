Return-Path: <linux-kernel-owner+w=401wt.eu-S1756642AbYJQUiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642AbYJQUiB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 16:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbYJQUhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 16:37:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:49418 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbYJQUhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 16:37:52 -0400
Cc: LinuxPPC-dev <linuxppc-dev@ozlabs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Message-Id: <FEFFA236-AA3B-49F1-AED2-E42950B87BD7@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Badari Pulavarty <pbadari@gmail.com>
In-Reply-To: <1224267073.15582.8.camel@badari-desktop>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: 2.6.27-git7 compile error (ppc)
Date: Fri, 17 Oct 2008 15:37:44 -0500
References: <1224265634.15582.3.camel@badari-desktop> <1224267073.15582.8.camel@badari-desktop>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 17, 2008, at 1:11 PM, Badari Pulavarty wrote:

> On Fri, 2008-10-17 at 10:47 -0700, Badari Pulavarty wrote:
>> Hi,
>>
>> I get this following compile error on my ppc box.
>>
>> Let me know if its a known issue. Otherwise, I can figure out
>> whats happening.
>>
>> Thanks,
>> Badari
>
> This is due to recent changes to move phys_add_t definition from
> arch/powerpc/include/asm/types.h to include/linux/types.h.
>
> arch/powerpc/include/asm/page.h needs phys_addr_t for
> CONFIG_RELOCATABLE. Needs fixing..
>
> Thanks,
> Badari
>
>>
>>  CC      arch/powerpc/mm/slb.o
>> In file included from /usr/src/linux-2.6.27/arch/powerpc/include/ 
>> asm/mmu-hash64.h:16,
>>                 from /usr/src/linux-2.6.27/arch/powerpc/include/asm/ 
>> mmu.h:7,
>>                 from /usr/src/linux-2.6.27/arch/powerpc/include/asm/ 
>> pgtable.h:7,
>>                 from arch/powerpc/mm/slb.c:19:
>> /usr/src/linux-2.6.27/arch/powerpc/include/asm/page.h:76: error:  
>> parse error before "memstart_addr"
>> /usr/src/linux-2.6.27/arch/powerpc/include/asm/page.h:76: warning:  
>> type defaults to `int' in declaration of `memstart_addr'
>> /usr/src/linux-2.6.27/arch/powerpc/include/asm/page.h:76: warning:  
>> data definition has no type or storage class
>> /usr/src/linux-2.6.27/arch/powerpc/include/asm/page.h:77: error:  
>> parse error before "kernstart_addr"
>> /usr/src/linux-2.6.27/arch/powerpc/include/asm/page.h:77: warning:  
>> type defaults to `int' in declaration of `kernstart_addr'
>> /usr/src/linux-2.6.27/arch/powerpc/include/asm/page.h:77: warning:  
>> data definition has no type or storage class
>>  AS      arch/powerpc/lib/string.o
>>  CC      arch/powerpc/lib/alloc.o
>>  CALL    arch/powerpc/kernel/systbl_chk.sh
>>  CC      arch/powerpc/kernel/sysfs.o
>> make[1]: *** [arch/powerpc/mm/slb.o] Error 1
>> make: *** [arch/powerpc/mm] Error 2
>> make: *** Waiting for unfinished jobs....

I've got a patch that seems to address this for me building w/ 
CONFIG_RELOCATABLE on ppc32/85xx.

- k
