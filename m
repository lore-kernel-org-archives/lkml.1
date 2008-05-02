Return-Path: <linux-kernel-owner+w=401wt.eu-S937010AbYEBVUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937010AbYEBVUo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 17:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932533AbYEBVUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 17:20:36 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:60014 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759607AbYEBVUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 17:20:36 -0400
Date: Sat, 3 May 2008 00:19:42 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       David Miller <davem@davemloft.net>, trini@kernel.crashing.org,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: huge gcc 4.1.{0,1} __weak problem
Message-ID: <20080502211942.GE5838@cs181133002.pp.htv.fi>
References: <20080430013108.GA18207@linux-os.sc.intel.com> <20080429.212833.192304794.davem@davemloft.net> <924EFEDD5F540B4284297C4DC59F3DEEF7D18E@orsmsx423.amr.corp.intel.com> <20080501215633.GU29330@cs181133002.pp.htv.fi> <481B8321.1000305@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <481B8321.1000305@goop.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 02:09:53PM -0700, Jeremy Fitzhardinge wrote:
> Adrian Bunk wrote:
>> A workaround here is the wrong solution since this isn't the only place 
>> that suffers from this issue.
>>
>> We currently give a #warning for 4.1.0.
>> But not for 4.1.1.
>> (Accordingto the bug >= 4.1.2 is fixed.)
>>
>> And a #warning is not enough.
>>
>> The huge problem is that "empty __weak function in the same file and  
>> non-weak arch function" has recently become a common pattern with  
>> several new usages added during this merge window alone.
>>
>> And the breakages can be very subtle runtime breakages.
>>
>> I see only the following choices:
>> - remove __weak and replace all current usages
>> - move all __weak functions into own files, and ensure that also happens
>>   for future usages
>> - #error for gcc 4.1.{0,1}
>>   
>
> - make __weak also include noinline.  I think that's sufficient (at  
> least it was when I encountered a gcc bug with these symptoms last year  
> or so).

I've tried it and it doesn't work.

>    J

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

