Return-Path: <linux-kernel-owner+w=401wt.eu-S1757464AbZCOGJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbZCOGJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 02:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbZCOGJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 02:09:51 -0400
Received: from gw.goop.org ([64.81.55.164]:57024 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbZCOGJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 02:09:50 -0400
Message-ID: <49BC9BAC.6090201@goop.org>
Date: Sat, 14 Mar 2009 23:09:48 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Latest brk patchset
References: <49BC413B.5020104@zytor.com> <49BC4CAC.202@goop.org> <49BC4DB6.9070403@zytor.com>
In-Reply-To: <49BC4DB6.9070403@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
>   
>>> It really doesn't make much sense to me, and is more than a bit
>>> confusing given the symbols.
>>>       
>> Mostly because I knew that the bss would get mapped into the appropriate
>> phdr segment correctly, but I wasn't sure that another bss-like section
>> would be.
>>     
>
> It will; in fact if they are adjacent then ld will typically merge the
> PHDRs.
>
>   
>> Also because historically the brk segment was just an
>> extension of the executable's bss, and its more or less the same too.
>>     
>
> An extension of, yes, but not a part of.
>
>   
>> Is there any real benefit in putting it into another section?
>>     
>
> Well, the semantics are different; the .bss section is zeroed while the
> brk isn't,
Traditionally, brk is always zeroed.  extend_brk() zeros the memory it 
returns (to be consistent with bootmem, and to make it easier to migrate 
from bss -> brk).

>  and the brk symbols don't necessarily point to the data
> associated with those particular symbols, unlike (of course) the bss.
>   

Yes, its a bit of a pitfall.  I guess the symbols are useful as a way to 
identify brk users just from looking at the vmlinux, but they're not 
really all that useful.  I'm half thinking we should put some non-C 
identifier characters in them to make sure that C code can never refer 
to them.

    J
