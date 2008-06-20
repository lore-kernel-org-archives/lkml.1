Return-Path: <linux-kernel-owner+w=401wt.eu-S1760015AbYFTV0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760015AbYFTV0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 17:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754566AbYFTV0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 17:26:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859AbYFTV0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 17:26:39 -0400
Date: Fri, 20 Jun 2008 17:26:35 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: David Miller <davem@davemloft.net>
cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, agk@redhat.com
Subject: Re: stack overflow on Sparc64
In-Reply-To: <20080620.133721.95818057.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0806201717190.14221@engineering.redhat.com>
References: <Pine.LNX.4.64.0806201143110.8789@engineering.redhat.com>
 <20080620.102601.06998427.davem@davemloft.net>
 <Pine.LNX.4.64.0806201624280.3668@engineering.redhat.com>
 <20080620.133721.95818057.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2008, David Miller wrote:

> From: Mikulas Patocka <mpatocka@redhat.com>
> Date: Fri, 20 Jun 2008 16:34:23 -0400 (EDT)
>
>> And what if network softirq happened here? How much stack does it consume?
>>
>> The whole overflowed stack trace has 75 functions, I was able to get rid
>> of 9 by avoiding bio_endio recursion and 10 by turning simple functions
>> into inlines. --- so is it enough or not enough for possible networking
>> calls?
>
> It should be OK, because the minimum stack of a (75 - 19) depth call
> chain is under 11K and within safe limits I believe.

I meant if some fancy networking options can eat those 19 frames that I 
saved and crash again? I use the computer as a workstation, it doesn't 
have high network load and it doesn't use any features except basic 
TCP/IP.

>> Maybe a good thing would be to add a check for stack size to __do_softirq
>> and handing the softirq to ksoftirqd if there's not enough space.
>
> I'd rather it spit out a WARN_ON() message and a backtrace.
>
> Otherwise it will be considered a feature and people won't fix
> these deep call chains.

If you think that process context+network processing+hardirqs can fit into 
75 nested functions... I really have no idea how much the networking 
takes, given the amount of protocols and features and inability to test 
them all in one lab, it looks very scary.

Mikulas
