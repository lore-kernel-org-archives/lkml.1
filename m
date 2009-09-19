Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbZISLkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbZISLkc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 07:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbZISLka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 07:40:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbZISLka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 07:40:30 -0400
Message-ID: <4AB4C318.2020307@redhat.com>
Date: Sat, 19 Sep 2009 14:40:08 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Jim Meyering <jim@meyering.net>, Theodore Tso <tytso@mit.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: efficient access to "rotational";  new fcntl?
References: <87vdjgqcbd.fsf@meyering.net>	<20090918221658.GB28781@mit.edu>	<87pr9npdlc.fsf@meyering.net>	<20090919103149.54258081@infradead.org>	<87k4zvpak6.fsf@meyering.net>	<20090919111912.34a35f95@infradead.org>	<4AB4BC6A.3020104@redhat.com> <20090919133013.5a27290c@infradead.org>
In-Reply-To: <20090919133013.5a27290c@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2009 02:30 PM, Arjan van de Ven wrote:
> On Sat, 19 Sep 2009 14:11:38 +0300
> Avi Kivity<avi@redhat.com>  wrote:
>
>    
>> On 09/19/2009 12:19 PM, Arjan van de Ven wrote:
>>      
>>>> However, sort *would* benefit, and some UCLA students implemented
>>>> that for a term project.  Unfortunately, the project is stalled
>>>> because the implementation was not efficient enough, and no one
>>>> has found the time to improve it since.
>>>>
>>>>          
>>> parallel sort... call me skeptical. My gut feeling is that you'll
>>> get killed by communication overhead.
>>> (sort seems to be more communication than raw cpu use)
>>>
>>>
>>>        
>> Why?  a sort that fits in memory is purely cpu and memory access.
>>      
> memory access == communication due to cache line bounces....
>    


For a large sort cache line bounces will be negligible.  First, memory 
size greatly exceeds cache size.  Second, every cach eline will be 
accessed multiple times.

If you're sorting 2MB, then yes, threads aren't needed.

>> Instead of O(N log N) you'd get K * O(N/K log N/K) followed by an
>> O(N) merge.  For large N and small K, you get a speedup of roughly K
>> (since the O(N) merge is dominated by the preceding sort.
>>      
> doing big-O arithmatic and then add constant divisions/multipliers is
> rather.. dangerous ;)
>    

I'm wearing my seat belt.

> You actually get K * C1 * O(N/K log N/K) + C2 * O(N)
> where C1/C2 is the actual cost of the extra intra-cpu communication.
> (and for most sorting, I suspect the communication costs dominate over
> CPU cost)
>
> I'd be happy to be proven wrong...
>    

Again, if the dataset is large, only a small fraction of the cache lines 
will be on another cpu.  The majority will be in main memory.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

