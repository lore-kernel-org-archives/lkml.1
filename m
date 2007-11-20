Return-Path: <linux-kernel-owner+w=401wt.eu-S1758899AbXKTGNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899AbXKTGNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 01:13:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757483AbXKTGNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 01:13:24 -0500
Received: from ro-out-1112.google.com ([72.14.202.179]:62255 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757000AbXKTGNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 01:13:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Xw4pkVmIhKIxOVqVS7XyzNbK1LiFc7PZp0y++f4bkGJpLFNP8H+LM0C46pHV8fBqk9U6EGv97vmyijT8YGvpk71spA34iHbogCYjxd/PWTOAaODTJmjzeeHjiZ/fMbE/upqyDTDutVzdsachFQ8rF0Q7tULQDodhRigcHWN43bo=
Date: Tue, 20 Nov 2007 14:10:52 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, zhengyi <goodmenkernel@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Is there any word about this bug in gcc ?
Message-ID: <20071120061052.GJ2472@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20071120.101342.85695496.goodmenzy@gmail.com> <20071120041600.GC2472@hacking> <47426C54.9020009@zytor.com> <20071120053904.GG2472@hacking> <474278A0.50803@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474278A0.50803@cn.fujitsu.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2007 at 02:03:12PM +0800, Li Zefan wrote:
>WANG Cong wrote:
>> On Mon, Nov 19, 2007 at 09:10:44PM -0800, H. Peter Anvin wrote:
>>> WANG Cong wrote:
>>>> On Tue, Nov 20, 2007 at 10:13:42AM +0800, zhengyi wrote:
>>>>> Is there any relevance to the kernel ?
>>>>>
>>>>> I found the folowing code here:
>>>>> http://linux.solidot.org/article.pl?sid=07/11/19/0512218&from=rss
>>>>>
>>>>> -------------------------------------------------------------------
>>>>> int main( void )
>>>>> {
>>>>> int i=2;
>>>>> if( -10*abs (i-1) == 10*abs(i-1) )
>>>>>   printf ("OMG,-10==10 in linux!\n");
>>>>> else
>>>>>   printf ("nothing special here\n") ;
>>>>>
>>>>> return 0 ;
>>>>> }
>>>> I think no. It is considered a bug in abs(), kernel, of course,
>>>> doesn't use glibc's abs().
>>>>
>>> Wrong.
>>>
>>> abs() is internal to gcc, and the above is optimized out at compile 
>>> time, so any user of abs() as a function at all is vulnerable.
>> 
>> This is an urgent bug, I think.
>> 
>> And you mean abs() is not in glibc, then where is it? Built in gcc?
>> And what's more, why not put it in glibc?
>> 
>
>Gcc optimises abs() to use gcc builtin-in abs(). So if we use -fno-builin, 
>we'll get the correct result. That is to say the bug has nothing to do with
>glibc.
>
>And this bug has been fixed just several days ago.
>
>http://www.nabble.com/-PATCH--Fix-PR34130,-extract_muldiv-broken-t4826688.html
>

Good explanation! Thank you!


