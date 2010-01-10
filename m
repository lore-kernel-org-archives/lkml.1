Return-Path: <linux-kernel-owner+w=401wt.eu-S1751327Ab0AJF3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327Ab0AJF3g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 00:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160Ab0AJF3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 00:29:36 -0500
Received: from mail-iw0-f194.google.com ([209.85.223.194]:47123 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab0AJF3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 00:29:35 -0500
Message-ID: <4B496546.5010607@vflare.org>
Date: Sun, 10 Jan 2010 10:57:34 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Ed Tomlinson <edt@aei.ca>
CC: Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, cl@linux-foundation.org,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
References: <20100104182429.833180340@chello.nl> <alpine.LFD.2.00.1001052007090.3630@localhost.localdomain> <1262969610.4244.36.camel@laptop> <201001090947.57479.edt@aei.ca>
In-Reply-To: <201001090947.57479.edt@aei.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2010 08:17 PM, Ed Tomlinson wrote:
> On Friday 08 January 2010 11:53:30 Peter Zijlstra wrote:
>> On Tue, 2010-01-05 at 20:20 -0800, Linus Torvalds wrote:
>>>
>>> On Wed, 6 Jan 2010, KAMEZAWA Hiroyuki wrote:
>>>>>
>>>>> Of course, your other load with MADV_DONTNEED seems to be horrible, and 
>>>>> has some nasty spinlock issues, but that looks like a separate deal (I 
>>>>> assume that load is just very hard on the pgtable lock).
>>>>
>>>> It's zone->lock, I guess. My test program avoids pgtable lock problem.
>>>
>>> Yeah, I should have looked more at your callchain. That's nasty. Much 
>>> worse than the per-mm lock. I thought the page buffering would avoid the 
>>> zone lock becoming a huge problem, but clearly not in this case.
>>
>> Right, so I ran some numbers on a multi-socket (2) machine as well:
>>
>>                                pf/min
>>
>> -tip                          56398626
>> -tip + xadd                  174753190
>> -tip + speculative           189274319
>> -tip + xadd + speculative    200174641
> 
> Has anyone tried these patches with ramzswap?  Nitin do they help with the locking
> issues you mentioned?
> 

Locking problem with ramzswap seems completely unrelated to what is being discussed here.

Thanks,
Nitin
