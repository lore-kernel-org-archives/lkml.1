Return-Path: <linux-kernel-owner+w=401wt.eu-S1752765AbXJUULD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbXJUULD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 16:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbXJUUKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 16:10:54 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:35215 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbXJUUKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 16:10:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=SZ4PIjL2wwvbU56ayQatWhr/purTHbf/Ek9Jy5Lu8jQ8yr19p0E3LHB43K1+Y6zo2GGlgmRygoK+8aqX11t79RirWwXuKrSmGxTGfJM/Mvd9zkU9BVA1W7fo5ZfixHY2GbOQR/Z3Blkm5YNJYbsptf76U1AFn9mNNsdGW8tqbbg=
Message-ID: <471BB242.7050504@googlemail.com>
Date: Sun, 21 Oct 2007 22:10:42 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Gabriel C <crazy@pimpmylinux.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: some kernel headers broken in current git ?
References: <4719174A.7020004@googlemail.com> <471AD5AD.9030000@zytor.com> <471B2918.5090502@googlemail.com> <471B487C.5080209@googlemail.com> <471BA564.3040305@zytor.com>
In-Reply-To: <471BA564.3040305@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Gabriel C wrote:
>>>> BITS_PER_LONG was originally set in <asm/types.h>:
>>>>
>>>>      39  #ifdef CONFIG_X86_32
>>>>      40  # define BITS_PER_LONG 32
>>>>      41  #else
>>>>      42  # define BITS_PER_LONG 64
>>>>      43  #endif
>>> User land does not know anything about 'CONFIG_X86_32' right ?
> 
> Wait... this is *user mode* code at this point?
> 
> Linux kernel headers aren't includable from user space without 
> processing them through "make headers_install".
> 
> However, from looking at the filenames in your list, it doesn't look 
> like userspace code at all (although they're wrappered to the degree 
> that it's somewhat hard to tell.)  Thus, you're building a kernel 
> module, not userland.

Hmm right is building an kernel modules.

> 
>> That is the problem. I've changed the headers virtualbox need from 
>>
>> #ifdef CONFIG_X86_32 to #ifdef __i386__ and all compiled fine. 
>>
>> ( subarch headers includes are changed manually still but I think it is the same problem )
>>
>> Also all the headers got these defines with CONFIG_X86_32 does not work.
>>
>> ...
>>
>> #ifdef CONFIG_X86_32
>> # include "foo_32.h"
>> #else
>> # include "foo_64.h"
>> #endif
>>
>> ...
>>
>> results in including both header files on my i686 box.
>>
>> I don't know what the right way is to fix that , define some who CONFIG_X86_32 to __i386__ ? or just s/CONFIG_X86_32/__i386__/ ?
> 
> It sounds like something is seriously broken in your setup, or in the 
> VirtualBox makefiles.  From the looks of it, I would say the latter.
> 
> It would help to see how gcc is invoked, but your email message doesn't 
> include any gcc invocations, and your "full error log" weblink is 
> broken, so it's hard to say.


Sorry that box was down some hours I've tested some hardware.

Here is a full build log , virtualbox build against cfa76f024f7c9e65169425804e5b32e71f66d0ee :


http://194.231.229.228/virtualbox-build.log.tar.bz2


Gabriel
