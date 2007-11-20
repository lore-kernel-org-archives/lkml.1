Return-Path: <linux-kernel-owner+w=401wt.eu-S1757972AbXKTFmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972AbXKTFmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 00:42:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbXKTFl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 00:41:56 -0500
Received: from ro-out-1112.google.com ([72.14.202.176]:40493 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbXKTFlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 00:41:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ekGiM4v5/bb8flhJKPGZOoh/WE7hZwCh6Cj7XjEmHs3B3sCZzIHerJRWO45qM2XZrHkzn24jCMo0A85lTqkqaLV0zKIHwSipKwTpuF3mbA89U7s1BFfZ1Tk4E1jvCsqiuh/VZj0cGG0Ta5Un/v+MrdVvvSZrIwsMRSigW6N8Rb0=
Date: Tue, 20 Nov 2007 13:39:05 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, zhengyi <goodmenkernel@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Is there any word about this bug in gcc ?
Message-ID: <20071120053904.GG2472@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20071120.101342.85695496.goodmenzy@gmail.com> <20071120041600.GC2472@hacking> <47426C54.9020009@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47426C54.9020009@zytor.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 09:10:44PM -0800, H. Peter Anvin wrote:
>WANG Cong wrote:
>>On Tue, Nov 20, 2007 at 10:13:42AM +0800, zhengyi wrote:
>>>Is there any relevance to the kernel ?
>>>
>>>I found the folowing code here:
>>>http://linux.solidot.org/article.pl?sid=07/11/19/0512218&from=rss
>>>
>>>-------------------------------------------------------------------
>>>int main( void )
>>>{
>>> int i=2;
>>> if( -10*abs (i-1) == 10*abs(i-1) )
>>>   printf ("OMG,-10==10 in linux!\n");
>>> else
>>>   printf ("nothing special here\n") ;
>>>
>>> return 0 ;
>>>}
>>
>>I think no. It is considered a bug in abs(), kernel, of course,
>>doesn't use glibc's abs().
>>
>
>Wrong.
>
>abs() is internal to gcc, and the above is optimized out at compile 
>time, so any user of abs() as a function at all is vulnerable.

This is an urgent bug, I think.

And you mean abs() is not in glibc, then where is it? Built in gcc?
And what's more, why not put it in glibc?

Thanks.

>
>However, the Linux kernel defines abs() as a macro:
>
>#define abs(x) ({                               \
>                int __x = (x);                  \
>                (__x < 0) ? -__x : __x;         \
>        })
>
>... which means gcc never sees it.  So the kernel isn't affected, 
>because it doesn't use *gcc's* abs().

Thanks for clarifying this!

Regards.


