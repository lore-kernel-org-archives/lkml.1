Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbZICNq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbZICNq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 09:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbZICNq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 09:46:57 -0400
Received: from mail.tmr.com ([64.65.253.246]:48761 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011AbZICNq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 09:46:57 -0400
Message-ID: <4A9FC8CE.3070005@tmr.com>
Date: Thu, 03 Sep 2009 09:46:54 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Adayadil Thomas <adayadil.thomas@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: LowFree pattern
References: <fb7befa20909020932k74fa9e37x1eeabdb494835bb9@mail.gmail.com>	 <h7mgl3$v6$1@ger.gmane.org> <fb7befa20909021520o110b9159led09237e72da469e@mail.gmail.com>
In-Reply-To: <fb7befa20909021520o110b9159led09237e72da469e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adayadil Thomas wrote:
>> What problem did you see that you traced to LowFree?
>>     
>
> I have set this device as a bridge. Higher latency and low throughput seem
> to be related to LowFree. There are also packet drops at the interface
> when LowFree is too low.
>
> I have another device which has 4G RAM split into 900M LowMem and
> the rest as HighMem. In that case also, LowMem goes to a low level, say 8M
> and although HighMem has ~2G free, the system gives OOPS (related to
> page_alloc failures)
> when acting as a bridge (passing packets).
>
>   
Then /proc/sys/vm tuning may help.
>
>
> On Wed, Sep 2, 2009 at 3:22 PM, Bill Davidsen<davidsen@tmr.com> wrote:
>   
>> Adayadil Thomas wrote:
>>     
>>> Greetings.
>>>
>>> I am running a centos linux with 2.6.20 version kernel. The system has
>>> 1G of RAM.
>>>
>>> As time goes by the LowFree becomes really low. Right now it shows
>>> 137M .. but it goes as low as 8M or so
>>>
>>> The command -
>>> echo 3 > /proc/sys/vm/drop_caches
>>> brings back the LowFree to way up high.
>>>
>>> The question I have is whether the system by itself release the cache
>>> (drop cache) automatically
>>> to maintain a reasonable LowFree?
>>> Is this configurable?
>>>
>>>       
>> You can change the parameters in /rpoc/sys/vm if you wish, but what makes
>> you think this is needed? Cache is dropped as memory is needed, and
>> drop_cache in general is a good way to slow the system.
>>
>>     
>>> Any information or help is much appreciated.
>>>
>>>       
>> What problem did you see that you traced to LowFree?
>>
>>     
>>> cat /proc/meminfo
>>> MemTotal:      1034788 kB
>>> MemFree:        138240 kB
>>> Buffers:         99260 kB
>>> Cached:         177776 kB
>>> SwapCached:      51740 kB
>>> Active:         605172 kB
>>> Inactive:       113572 kB
>>> HighTotal:      130720 kB
>>> HighFree:          252 kB
>>> LowTotal:       904068 kB
>>> LowFree:        137988 kB
>>> SwapTotal:     1048568 kB
>>> SwapFree:       976332 kB
>>> Dirty:             380 kB
>>> Writeback:           0 kB
>>> AnonPages:      441348 kB
>>> Mapped:          15540 kB
>>> Slab:           146088 kB
>>> SReclaimable:   104288 kB
>>> SUnreclaim:      41800 kB
>>> PageTables:       1596 kB
>>> NFS_Unstable:        0 kB
>>> Bounce:              0 kB
>>> CommitLimit:   1565960 kB
>>> Committed_AS:   590576 kB
>>> VmallocTotal:   114680 kB
>>> VmallocUsed:     15052 kB
>>> VmallocChunk:    99348 kB
>>>       


-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"Now we have another quarterback besides Kurt Warner telling us during postgame
interviews that he owes every great thing that happens to him on a football
field to his faith in Jesus. I knew there had to be a reason why the Almighty
included a mute button on my remote."
			-- Arthur Troyer on Tim Tebow (Sports Illustrated)

