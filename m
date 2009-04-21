Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbZDUJqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbZDUJqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 05:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754095AbZDUJqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 05:46:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:47859 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbZDUJqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 05:46:09 -0400
Message-ID: <49ED95DE.5070804@petalogix.com>
Date: Tue, 21 Apr 2009 11:46:06 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-arch@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Microblaze noMMU/MMU merge
References: <49ED79AB.10004@petalogix.com> <20090421082523.GA19864@uranus.ravnborg.org>
In-Reply-To: <20090421082523.GA19864@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Tue, Apr 21, 2009 at 09:45:47AM +0200, Michal Simek wrote:
>   
>> Hi All,
>>
>> I would like to say your opinion about putting together Microblaze MMU
>> arch to noMMU version.
>>
>> In C code will be #ifdef CONFIG_MMU ... #endif  or #ifndef.
>>
>> Here is proposal for headers. The similar style is used in m68k but I
>> would like to have the same code
>> for both archs in main file.
>>
>> #ifndef _ASM_MICROBLAZE_PAGE_H
>> #define _ASM_MICROBLAZE_PAGE_H
>>
>> code for noMMU and MMU which is the same for both.
>>
>> #ifdef __uClinux__
>> #include "page_no.h" -> noMMU specific
>> #else
>> #include "page_mm.h"-> MMU specific
>> #endif
>> #endif /* _ASM_MICROBLAZE_PAGE_H */
>>     
>
> Use dedicated header files for nommu / mmu only when it is really necessary.
>
> In headers that are _NOT_ exported you can use CONFIG_MMU to test
> if you are building for MMU or not - which is more readable.
>  
> The reason why you cannot use CONFIG_MMU in exported headers
> are that CONFIG_MMU is not valid in the userspace headers (not set/unset).
>
> In the optimal case you have no conditionals in the exported haders
> and then just use CONFIG_MMU all over.
>   
ok. I'll create first proposal and you can look if is ok or not.

Thanks.
Michal

> 	Sam
>
>   


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

