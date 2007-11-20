Return-Path: <linux-kernel-owner+w=401wt.eu-S1755736AbXKTFLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736AbXKTFLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 00:11:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbXKTFKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 00:10:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50486 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbXKTFKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 00:10:51 -0500
Message-ID: <47426C54.9020009@zytor.com>
Date: Mon, 19 Nov 2007 21:10:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: WANG Cong <xiyou.wangcong@gmail.com>
CC: zhengyi <goodmenkernel@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Is there any word about this bug in gcc ?
References: <20071120.101342.85695496.goodmenzy@gmail.com> <20071120041600.GC2472@hacking>
In-Reply-To: <20071120041600.GC2472@hacking>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

WANG Cong wrote:
> On Tue, Nov 20, 2007 at 10:13:42AM +0800, zhengyi wrote:
>> Is there any relevance to the kernel ?
>>
>> I found the folowing code here:
>> http://linux.solidot.org/article.pl?sid=07/11/19/0512218&from=rss
>>
>> -------------------------------------------------------------------
>> int main( void )
>> {
>>  int i=2;
>>  if( -10*abs (i-1) == 10*abs(i-1) )
>>    printf ("OMG,-10==10 in linux!\n");
>>  else
>>    printf ("nothing special here\n") ;
>>
>>  return 0 ;
>> }
> 
> I think no. It is considered a bug in abs(), kernel, of course,
> doesn't use glibc's abs().
> 

Wrong.

abs() is internal to gcc, and the above is optimized out at compile 
time, so any user of abs() as a function at all is vulnerable.

However, the Linux kernel defines abs() as a macro:

#define abs(x) ({                               \
                 int __x = (x);                  \
                 (__x < 0) ? -__x : __x;         \
         })

... which means gcc never sees it.  So the kernel isn't affected, 
because it doesn't use *gcc's* abs().

	-hpa

