Return-Path: <linux-kernel-owner+w=401wt.eu-S1756552AbXKTGGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbXKTGGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 01:06:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757916AbXKTGGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 01:06:12 -0500
Received: from [222.73.24.84] ([222.73.24.84]:61482 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757548AbXKTGGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 01:06:08 -0500
Message-ID: <474278A0.50803@cn.fujitsu.com>
Date: Tue, 20 Nov 2007 14:03:12 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: WANG Cong <xiyou.wangcong@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, zhengyi <goodmenkernel@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Is there any word about this bug in gcc ?
References: <20071120.101342.85695496.goodmenzy@gmail.com> <20071120041600.GC2472@hacking> <47426C54.9020009@zytor.com> <20071120053904.GG2472@hacking>
In-Reply-To: <20071120053904.GG2472@hacking>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

WANG Cong wrote:
> On Mon, Nov 19, 2007 at 09:10:44PM -0800, H. Peter Anvin wrote:
>> WANG Cong wrote:
>>> On Tue, Nov 20, 2007 at 10:13:42AM +0800, zhengyi wrote:
>>>> Is there any relevance to the kernel ?
>>>>
>>>> I found the folowing code here:
>>>> http://linux.solidot.org/article.pl?sid=07/11/19/0512218&from=rss
>>>>
>>>> -------------------------------------------------------------------
>>>> int main( void )
>>>> {
>>>> int i=2;
>>>> if( -10*abs (i-1) == 10*abs(i-1) )
>>>>   printf ("OMG,-10==10 in linux!\n");
>>>> else
>>>>   printf ("nothing special here\n") ;
>>>>
>>>> return 0 ;
>>>> }
>>> I think no. It is considered a bug in abs(), kernel, of course,
>>> doesn't use glibc's abs().
>>>
>> Wrong.
>>
>> abs() is internal to gcc, and the above is optimized out at compile 
>> time, so any user of abs() as a function at all is vulnerable.
> 
> This is an urgent bug, I think.
> 
> And you mean abs() is not in glibc, then where is it? Built in gcc?
> And what's more, why not put it in glibc?
> 

Gcc optimises abs() to use gcc builtin-in abs(). So if we use -fno-builin, 
we'll get the correct result. That is to say the bug has nothing to do with
glibc.

And this bug has been fixed just several days ago.

http://www.nabble.com/-PATCH--Fix-PR34130,-extract_muldiv-broken-t4826688.html

> 
>> However, the Linux kernel defines abs() as a macro:
>>
>> #define abs(x) ({                               \
>>                int __x = (x);                  \
>>                (__x < 0) ? -__x : __x;         \
>>        })
>>
>> ... which means gcc never sees it.  So the kernel isn't affected, 
>> because it doesn't use *gcc's* abs().
> 
> Thanks for clarifying this!
> 
> Regards.
> 

