Return-Path: <linux-kernel-owner+w=401wt.eu-S1760379AbXGCXKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760379AbXGCXKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 19:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755276AbXGCXKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 19:10:35 -0400
Received: from gw.goop.org ([64.81.55.164]:42489 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133AbXGCXKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 19:10:34 -0400
Message-ID: <468AD767.10700@goop.org>
Date: Tue, 03 Jul 2007 16:10:31 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 06/10] Immediate Value - i386 Optimization
References: <20070703164046.645090494@polymtl.ca> <20070703164515.071300768@polymtl.ca> <468A9956.9050903@zytor.com> <20070703191605.GB4047@Krystal> <468AAF1F.6010909@zytor.com> <468AB390.7000608@redhat.com>
In-Reply-To: <468AB390.7000608@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> On 07/03/2007 04:18 PM, H. Peter Anvin wrote:
>   
>> One could, though, use an indirect jump to achieve, if not as good, at
>> least most of the effect:
>>
>> 	movl	$<patchable>,<reg>
>> 	jmp	*<reg>
>>
>>     
>
> Yeah, but there's this GCC bug:
>
> 	http://gcc.gnu.org/bugzilla/show_bug.cgi?id=22448
>
> You can't even dereference labels in an ASM statement.

I was told in absolute terms that any use of &&label other than to pass 
it to goto was not supported, and would not be supported.

http://gcc.gnu.org/bugzilla/show_bug.cgi?id=29305

Seems that passing to an asm() falls into the same class of problem I 
had.  I think the underlying problem is that if the code containing the 
label is in an inlined function or unrolled loop, the reference can't be 
resolved properly anyway.

    J
