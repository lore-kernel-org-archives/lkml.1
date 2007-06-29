Return-Path: <linux-kernel-owner+w=401wt.eu-S933167AbXF2Fc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167AbXF2Fc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 01:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755371AbXF2FcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 01:32:19 -0400
Received: from gw.goop.org ([64.81.55.164]:57468 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754281AbXF2FcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 01:32:18 -0400
Message-ID: <46849926.8050702@goop.org>
Date: Fri, 29 Jun 2007 01:31:18 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Arch <linux-arch@vger.kernel.org>,
       Richard Henderson <rth@twiddle.net>, Ian Molton <spyro@f2s.com>,
       Russell King <rmk@arm.linux.org.uk>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Aubrey Li <aubrey.li@analog.com>, Mikael Starvik <starvik@axis.com>,
       David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>, Andi Kleen <ak@suse.de>,
       Tony Luck <tony.luck@intel.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Ralf Baechle <ralf@linux-mips.org>, Matthew Wilcox <matthew@wil.cx>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>,
       Miles Bader <uclinux-v850@lsi.nec.co.jp>,
       Chris Zankel <chris@zankel.net>
Subject: Re: [PATCH] cross-architecture ELF clean up
References: <20070620230854.246399397@goop.org>	<20070620230902.387008536@goop.org> <18052.36612.846937.794756@cargo.ozlabs.ibm.com>
In-Reply-To: <18052.36612.846937.794756@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
>> ===================================================================
>> --- a/arch/powerpc/platforms/cell/io-workarounds.c
>> +++ b/arch/powerpc/platforms/cell/io-workarounds.c
>> @@ -9,6 +9,7 @@
>>  #undef DEBUG
>>  
>>  #include <linux/kernel.h>
>> +#include <linux/sched.h>
>>     
>
> Why is this needed?  You've added #include <linux/sched.h> to 7 files
> without explanation - and I can't see that you have removed a
> corresponding #include from any header, have you?
>   

asm-powerpc/elf.h included sched.h, and it in turn was being included by 
something else.  With the cleanups in this patch, asm-powerpc/elf.h is 
no longer being included, so io-workarounds.c needs kernel/sched.h for a 
declaration of init_mm.

Similarly with the others; they all failed to compile without linux/sched.h.

    J
