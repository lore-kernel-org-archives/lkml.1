Return-Path: <linux-kernel-owner+w=401wt.eu-S1760128AbXFAALs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128AbXFAALs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 20:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754178AbXFAALk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 20:11:40 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.133]:52176 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754671AbXFAALj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 20:11:39 -0400
Date: Thu, 31 May 2007 17:11:07 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH 4/5] serial: convert early_uart to earlycon for 8250
In-reply-to: <20070531165428.c6cdc042.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai.Lu@Sun.COM
Message-id: <465F641B.1070403@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=US-ASCII
Content-transfer-encoding: 7BIT
References: <200705311401.33715.yinghai.lu@sun.com>
 <20070531165428.c6cdc042.akpm@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 31 May 2007 14:01:33 -0700
> Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> 
>> Andrew,
>>
>> Please don't drop others if there is problem with this one.
>>
>> YH
>>
>> [PATCH 4/5] serial: convert early_uart to earlycon for 8250
>>
>> +config FIX_EARLYCON_MEM
>> +	bool
>> +	depends on X86
>> +	default y
>> +
> 
> It might have been nicer to do this in arch/i386/Kconfig and
> arch/x86_64/Kconfig.  That way we don't end up with a great string of arch
> selectors in non-arch Kconfig files (do "grep SPARC */Kconfig*")
> 
> otoh, doing that means that FIX_EARLYCON_MEM doesn't get mentioned in
> drivers/serial/Kconfig and you need to go on a great hunting expedition to
> find out who sets it.
> 

we could extend that to others arch that is support fixmap like
./asm-i386/fixmap.h
./asm-mips/fixmap.h
./asm-parisc/fixmap.h
./asm-sh/fixmap.h
./asm-sparc/fixmap.h
./asm-um/fixmap.h
./asm-x86_64/fixmap.h

so it will be
 >> +config FIX_EARLYCON_MEM
 >> +	bool
 >> +	depends on X86 || MIPS || PARISC || SH || SPARC || UM
 >> +	default y
 >> +

You you can provide another config like

CONFIG_FIXMAP

YH
