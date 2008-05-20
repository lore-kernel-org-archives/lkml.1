Return-Path: <linux-kernel-owner+w=401wt.eu-S1764058AbYETARx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764058AbYETARx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 20:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756145AbYETARp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 20:17:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40010 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188AbYETARp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 20:17:45 -0400
Message-ID: <4832189B.8000602@zytor.com>
Date: Mon, 19 May 2008 17:17:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Harvey Harrison <harvey.harrison@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] asm-generic/int-ll64.h: always provide __{s,u}64
References: <20080519215452.GK17716@cs181133002.pp.htv.fi> <4831F89F.5060106@zytor.com> <1211236048.5915.94.camel@brick> <20080519223232.GB17716@cs181133002.pp.htv.fi> <48321299.80303@zytor.com> <20080520001345.GG17716@cs181133002.pp.htv.fi>
In-Reply-To: <20080520001345.GG17716@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Mon, May 19, 2008 at 04:51:53PM -0700, H. Peter Anvin wrote:
>> Adrian Bunk wrote:
>>>> If it is going to be unconditionally offered, we could get rid of
>>>> __BYTEORDER_HAS_U64__ as a next step.  Unless there is something I've
>>>> missed.
>>> Why do we need the byteorder headers in userspace at all?
>>>
>> Because Linux-specific software has depended on them for over 15 years  
>> (they are a much better API than anything POSIX provides.)  We can't  
>> just yank them, and so it's better if they actually work.
>>
>> Yes, you can argue it should be glibc's job to provide them, but well,  
>> why duplicate work when we already have a nicely working set.
> 
> The worst thing is how many CONFIG_'s they currently leak to userspace.
> 
> And e.g. the versions in the x86 header are therefore not the fastest 
> ones (unless the userspace software #define's CONFIG_X86_BSWAP)...
> 

This is a valid point.  This should be __i486__ for userspace, which is 
gcc's way to tell you if you're compiling with -march=i486.

	-hpa
