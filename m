Return-Path: <linux-kernel-owner+w=401wt.eu-S932124AbXBVOyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124AbXBVOyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 09:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932154AbXBVOyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 09:54:17 -0500
Received: from il.qumranet.com ([82.166.9.18]:38212 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932124AbXBVOyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 09:54:16 -0500
Message-ID: <45DDAE64.8070603@argo.co.il>
Date: Thu, 22 Feb 2007 16:53:24 +0200
From: Avi Kivity <avi@argo.co.il>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: johnpol@2ka.mipt.ru, arjan@infradead.org, mingo@elte.hu,
       drepper@redhat.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, hch@infradead.org, akpm@zip.com.au,
       alan@lxorguk.ukuu.org.uk, zach.brown@oracle.com, suparna@in.ibm.com,
       davidel@xmailserver.org, jens.axboe@oracle.com, tglx@linutronix.de
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
References: <20070222113148.GA3781@2ka.mipt.ru>	<1172145159.3531.253.camel@laptopd505.fenrus.org>	<20070222123929.GA5208@2ka.mipt.ru> <20070222.054127.104035694.davem@davemloft.net>
In-Reply-To: <20070222.054127.104035694.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
> Date: Thu, 22 Feb 2007 15:39:30 +0300
>
>   
>> It does not matter - even with threads cost of having thousands of
>> threads is _too_ expensive. So, IMO, it is wrong to have to create 
>> 20k threads for the simple web server which only sends one index page to
>> 80k connections with 4k connections per seconds rate.
>>
>> Just have that example in mind - more than 20k blocks in 80k connections 
>> over gigabit lan, and it is likely optimistic result, when designing new 
>> type of AIO.
>>     
>
> I totally agree with Evgeniy on these points.
>
> Using things like syslets and threadlets for networking I/O
> is not a very good idea.  Blocking is more the norm than the
> exception for networking I/O.
>   

And for O_DIRECT, and for large storage systems which overwhelm caches.  
The optimize for the nonblocking case approach does not fit all 
workloads.  And of course we have to be able to mix mostly-nonblocking 
threadlets and mostly-blocking O_DIRECT and networking.


-- 
error compiling committee.c: too many arguments to function

