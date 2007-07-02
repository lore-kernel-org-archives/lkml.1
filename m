Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482AbXGBRhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbXGBRhw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 13:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbXGBRhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 13:37:43 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:25580 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbXGBRhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 13:37:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=g8yyrtihxf3s3OLIKtRZwqDU6MfLTvMSe3p9RFFCTsDdiAoiLzOjtigNpGQriVQmKrKkvAhqq8h4UUn1to07yz11Il9p46ZA2Zc6WVJMqPOH/9o3vgqXKaIslfXv9PtwYlkHa8cwGvyYm8dFXqcTDPYK9VNqhA89plirZwJfeYk=
Message-ID: <4689375C.2090505@gmail.com>
Date: Mon, 02 Jul 2007 12:35:24 -0500
From: William Tambe <tambewilliam@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Stas Sergeev <stsp@aknet.ru>, linux-kernel@vger.kernel.org
Subject: Re: Concerning a post that you made about expandable anonymous shared
 mappings
References: <468562F6.4010604@gmail.com> <Pine.LNX.4.64.0707021619020.32337@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0707021619020.32337@blonde.wat.veritas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, I have a good case, but my case may not sound interesting until you 
see it working.

Ok, I am developing a dynamic memory allocation routine which takes 
direct advantage of the ability of a machine to use Virtual Memory to 
make everything look contiguous and fast.

And it just doesn't make sens to have mmap() map ANONYMOUS shared memory 
and mremap() not to expand it and make the expanded area available.

I am not a 100% sure, but I don't think correcting its behavior would 
cause a problem.

Would you happen to know how I can work around that issue for now, and 
make writing in an expended area not to generate a Bus error?

Sincerely,
William Tambe


Hugh Dickins wrote:
> On Fri, 29 Jun 2007, William Tambe wrote:
> 
>> I read a post that you made about not being able to expand anonymous shared
>> mapping with mremap(). And I am actually having that issue now.
> 
> I guess you're referring to the thread at
> http://lkml.org/lkml/2004/6/16/155
> and you're asking either Stas or me.
> 
>> You made the post in 2004 and we are now in 2007. I would like to know if that
>> feature was added because the code below always fail with bus error on my
>> machine. I use glibc 2.5
> 
> You've answered your own question: we did not make the change Stas
> suggested, IIRC because I remained a little uneasy with that change
> in behaviour, and nobody else spoke up for it.
> 
> I haven't given it any thought since then:
> do you have a good case for us to reconsider it?
> 
> Hugh
> 
>> Thank you for helping.
>>
>> #define _GNU_SOURCE
>> #include <sys/mman.h>
>> #include <unistd.h>
>>
>> #include <stdio.h>
>>
>> main() {
>>         void *ptr;
>>         if ((ptr=mmap(0, 4096, PROT_READ|PROT_WRITE,
>>                 MAP_ANONYMOUS|MAP_SHARED|MAP_GROWSDOWN, 0, 0)) == -1) {
>>                 printf("failed to mmap\n");
>>                 return;
>>         }
>>
>>         if ((ptr=mremap(ptr, 4096, 8192, MREMAP_MAYMOVE)) == -1) {
>>                 printf("failed to mremap\n");
>>                 return;
>>         }
>>
>>         //why does this failed. I am well in the interval [4096, 8192]
>>         *(unsigned int *)(ptr + 4096 + 8)= 10;
>> }
> 
