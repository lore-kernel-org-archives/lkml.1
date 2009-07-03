Return-Path: <linux-kernel-owner+w=401wt.eu-S1758169AbZGCMrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169AbZGCMrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 08:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757916AbZGCMp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 08:45:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53030 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757913AbZGCMp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 08:45:56 -0400
Message-ID: <4A4DFD8B.3030104@vlnb.net>
Date: Fri, 03 Jul 2009 16:46:03 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ronald Moesbergen <intercommit@gmail.com>
CC: linux-kernel@vger.kernel.org, Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [RESEND] [PATCH] readahead:add blk_run_backing_dev
References: <4A3CD62B.1020407@vlnb.net> <4A48BBF9.6050408@vlnb.net>	 <a0272b440906290700v7367d1c1r7237fd6593be00d2@mail.gmail.com>	 <20090629142124.GA28945@localhost> <20090629150109.GA3534@localhost>	 <4A48DFC5.3090205@vlnb.net> <20090630010414.GB31418@localhost>	 <4A49EEF9.6010205@vlnb.net>	 <a0272b440907030214l4016422bxbc98fd003bfe1b3d@mail.gmail.com>	 <4A4DE3C1.5080307@vlnb.net> <a0272b440907030541w1448d378n6fcabbb555d45fcc@mail.gmail.com>
In-Reply-To: <a0272b440907030541w1448d378n6fcabbb555d45fcc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/ZzHjMu6IrQwvWMbU5mz1w/hgl8deWAf4H3X6
 NlV6EzAqCwYsOuikk5GT3yIIq9vxEZu/xobO96Us+QQs8HkiTO
 hg/4Irsi/620FyROz8KsQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ronald Moesbergen, on 07/03/2009 04:41 PM wrote:
> 2009/7/3 Vladislav Bolkhovitin <vst@vlnb.net>:
>> Ronald Moesbergen, on 07/03/2009 01:14 PM wrote:
>>>>> OK, now I tend to agree on decreasing max_sectors_kb and increasing
>>>>> read_ahead_kb. But before actually trying to push that idea I'd like
>>>>> to
>>>>> - do more benchmarks
>>>>> - figure out why context readahead didn't help SCST performance
>>>>>  (previous traces show that context readahead is submitting perfect
>>>>>  large io requests, so I wonder if it's some io scheduler bug)
>>>> Because, as we found out, without your http://lkml.org/lkml/2009/5/21/319
>>>> patch read-ahead was nearly disabled, hence there were no difference
>>>> which
>>>> algorithm was used?
>>>>
>>>> Ronald, can you run the following tests, please? This time with 2 hosts,
>>>> initiator (client) and target (server) connected using 1 Gbps iSCSI. It
>>>> would be the best if on the client vanilla 2.6.29 will be ran, but any
>>>> other
>>>> kernel will be fine as well, only specify which. Blockdev-perftest should
>>>> be
>>>> ran as before in buffered mode, i.e. with "-a" switch.
>>>>
>>>> 1. All defaults on the client, on the server vanilla 2.6.29 with
>>>> Fengguang's
>>>> http://lkml.org/lkml/2009/5/21/319 patch with all default settings.
>>>>
>>>> 2. All defaults on the client, on the server vanilla 2.6.29 with
>>>> Fengguang's
>>>> http://lkml.org/lkml/2009/5/21/319 patch with default RA size and 64KB
>>>> max_sectors_kb.
>>>>
>>>> 3. All defaults on the client, on the server vanilla 2.6.29 with
>>>> Fengguang's
>>>> http://lkml.org/lkml/2009/5/21/319 patch with 2MB RA size and default
>>>> max_sectors_kb.
>>>>
>>>> 4. All defaults on the client, on the server vanilla 2.6.29 with
>>>> Fengguang's
>>>> http://lkml.org/lkml/2009/5/21/319 patch with 2MB RA size and 64KB
>>>> max_sectors_kb.
>>>>
>>>> 5. All defaults on the client, on the server vanilla 2.6.29 with
>>>> Fengguang's
>>>> http://lkml.org/lkml/2009/5/21/319 patch and with context RA patch. RA
>>>> size
>>>> and max_sectors_kb are default. For your convenience I committed the
>>>> backported context RA patches into the SCST SVN repository.
>>>>
>>>> 6. All defaults on the client, on the server vanilla 2.6.29 with
>>>> Fengguang's
>>>> http://lkml.org/lkml/2009/5/21/319 and context RA patches with default RA
>>>> size and 64KB max_sectors_kb.
>>>>
>>>> 7. All defaults on the client, on the server vanilla 2.6.29 with
>>>> Fengguang's
>>>> http://lkml.org/lkml/2009/5/21/319 and context RA patches with 2MB RA
>>>> size
>>>> and default max_sectors_kb.
>>>>
>>>> 8. All defaults on the client, on the server vanilla 2.6.29 with
>>>> Fengguang's
>>>> http://lkml.org/lkml/2009/5/21/319 and context RA patches with 2MB RA
>>>> size
>>>> and 64KB max_sectors_kb.
>>>>
>>>> 9. On the client default RA size and 64KB max_sectors_kb. On the server
>>>> vanilla 2.6.29 with Fengguang's http://lkml.org/lkml/2009/5/21/319 and
>>>> context RA patches with 2MB RA size and 64KB max_sectors_kb.
>>>>
>>>> 10. On the client 2MB RA size and default max_sectors_kb. On the server
>>>> vanilla 2.6.29 with Fengguang's http://lkml.org/lkml/2009/5/21/319 and
>>>> context RA patches with 2MB RA size and 64KB max_sectors_kb.
>>>>
>>>> 11. On the client 2MB RA size and 64KB max_sectors_kb. On the server
>>>> vanilla
>>>> 2.6.29 with Fengguang's http://lkml.org/lkml/2009/5/21/319 and context RA
>>>> patches with 2MB RA size and 64KB max_sectors_kb.
>>> Ok, done. Performance is pretty bad overall :(
>>>
>>> The kernels I used:
>>> client kernel: 2.6.26-15lenny3 (debian)
>>> server kernel: 2.6.29.5 with blk_dev_run patch
>>>
>>> And I adjusted the blockdev-perftest script to drop caches on both the
>>> server (via ssh) and the client.
>>>
>>> The results:
>>>
> 
> ... results ...
> 
>> Those are on the server without io_context-2.6.29 and readahead-2.6.29
>> patches applied and with CFQ scheduler, correct?
> 
> No. It was done with the readahead patch
> (http://lkml.org/lkml/2009/5/21/319) and the context RA patch
> (starting at test 5) as you requested.

OK, just wanted to clear.

>> Then we see how reorder of requests caused by many I/O threads submitting
>> I/O in separate I/O contexts badly affect performance and no RA, especially
>> with default 128KB RA size, can solve it. Less max_sectors_kb on the client
>> => more requests it sends at once => more reorder on the server => worse
>> throughput. Although, Fengguang, in theory, context RA with 2MB RA size
>> should considerably help it, no?
> 
> Wouldn't setting scst_threads to 1 help also in this case?

Let's check it in another time.

>> Ronald, can you perform those tests again with both io_context-2.6.29 and
>> readahead-2.6.29 patches applied on the server, please?
> 
> Ok. I only have access to the test systems during the week, so results
> might not be ready before Monday. Are there tests that we can exclude
> to speed things up?

Unfortunately, no. But this isn't urgent at all, so next week is OK.

Thanks,
Vlad
