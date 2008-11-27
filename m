Return-Path: <linux-kernel-owner+w=401wt.eu-S1755373AbYK0NKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373AbYK0NKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 08:10:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbYK0NK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 08:10:27 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:13751 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbYK0NK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 08:10:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=jY5DTHwFMqhuzURSlFb6yfT8qD34iixVanndrQh/6f2iqXpnAQ1lCFpIvS/PcRxHVw
         vPztYB4brta16wN16iiF3Fl0ObYVqdCAt3yj/9M04c/bTNTe3NZBjotfSpSY/k/opbd6
         o92AYhvaZR2DJ3Xp78yDiQqDaA2N4/DFBtvkk=
Message-ID: <492E9C3C.9050507@gmail.com>
Date: Thu, 27 Nov 2008 15:10:20 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Mike Waychison <mikew@google.com>, Ying Han <yinghan@google.com>,
       Ingo Molnar <mingo@elte.hu>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rohit Seth <rohitseth@google.com>,
       Hugh Dickins <hugh@veritas.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC v1][PATCH]page_fault retry with NOPAGE_RETRY
References: <604427e00811251042t1eebded6k9916212b7c0c2ea0@mail.gmail.com> <20081126123246.GB23649@wotan.suse.de> <492DAA24.8040100@google.com> <20081127085554.GD28285@wotan.suse.de> <492E6849.6090205@google.com> <492E8708.4060601@gmail.com> <20081127120330.GM28285@wotan.suse.de> <492E90BC.1090208@gmail.com> <20081127123926.GN28285@wotan.suse.de> <492E97FA.5000804@gmail.com> <20081127130525.GO28285@wotan.suse.de>
In-Reply-To: <20081127130525.GO28285@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-11-27 15:05, Nick Piggin wrote:
> On Thu, Nov 27, 2008 at 02:52:10PM +0200, Török Edwin wrote:
>   
>> On 2008-11-27 14:39, Nick Piggin wrote:
>>     
>>> And then you also get the advantages of reduced contention on other
>>> shared locks and resources.
>>>   
>>>       
>> Thanks for the tips, but lets get back to the original question:
>> why don't I see any performance improvement with the fault-retry patches?
>>     
>
> Because as you said, your app is CPU bound and page faults aren't needing
> to sleep very much. There is too much contention on the write side, rather
> than too much contention/hold time on the read side.
>
>  
>   
>> My testcase only compares reads file with mmap, vs. reading files with
>> read, with different number of threads.
>> Leaving aside other reasons why mmap is slower, there should be some
>> speedup by running 4 threads vs 1 thread, but:
>>
>> 1 thread: read:27,18 28.76
>> 1 thread: mmap: 25.45, 25.24
>> 2 thread: read: 16.03, 15.66
>> 2 thread: mmap: 22.20, 20.99
>> 4 thread: read: 9.15, 9.12
>> 4 thread: mmap: 20.38, 20.47
>>
>> The speed of 4 threads is about the same as for 2 threads with mmap, yet
>> with read it scales nicely.
>> And the patch doesn't seem to improve scalability.
>> How can I find out if the patch works as expected? [i.e. verify that
>> faults are actually retried, and that they don't keep the semaphore locked]
>>     
>
> Yeah, that workload will be completely contended on the mmap_sem write-side
> if the files are in cache. The google patch won't help at all in that
> case.
>   

Ok. Sorry for hijacking the thread, my testcase is not a good testcase
for what this patch tries to solve.

Best regards,
--Edwin
