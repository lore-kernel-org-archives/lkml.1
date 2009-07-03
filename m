Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbZGCMlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbZGCMlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 08:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757313AbZGCMl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 08:41:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:46244 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756344AbZGCMlZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 08:41:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YC7NeL9QrYjgt+flkw/nQgkfFHP5xCJt4IXYb3Z07Tehtjg52Z2ovEsm/7r4FVukRn
         Wz6tiFHoUb8YXJQ3yZQ1AGVKrOePRl1JGto8zv1fhAhKNWhjYn0vsMNjVdg7esTj8HBc
         ojRSM+eekYF1nCqNrjABvxpHNmiyW3EKvjfI8=
MIME-Version: 1.0
In-Reply-To: <4A4DE3C1.5080307@vlnb.net>
References: <4A3CD62B.1020407@vlnb.net> <4A48BBF9.6050408@vlnb.net>
	 <a0272b440906290700v7367d1c1r7237fd6593be00d2@mail.gmail.com>
	 <20090629142124.GA28945@localhost> <20090629150109.GA3534@localhost>
	 <4A48DFC5.3090205@vlnb.net> <20090630010414.GB31418@localhost>
	 <4A49EEF9.6010205@vlnb.net>
	 <a0272b440907030214l4016422bxbc98fd003bfe1b3d@mail.gmail.com>
	 <4A4DE3C1.5080307@vlnb.net>
Date: Fri, 3 Jul 2009 14:41:28 +0200
Message-ID: <a0272b440907030541w1448d378n6fcabbb555d45fcc@mail.gmail.com>
Subject: Re: [RESEND] [PATCH] readahead:add blk_run_backing_dev
From: Ronald Moesbergen <intercommit@gmail.com>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-kernel@vger.kernel.org, Wu Fengguang <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/3 Vladislav Bolkhovitin <vst@vlnb.net>:
>
> Ronald Moesbergen, on 07/03/2009 01:14 PM wrote:
>>>>
>>>> OK, now I tend to agree on decreasing max_sectors_kb and increasing
>>>> read_ahead_kb. But before actually trying to push that idea I'd like
>>>> to
>>>> - do more benchmarks
>>>> - figure out why context readahead didn't help SCST performance
>>>>  (previous traces show that context readahead is submitting perfect
>>>>  large io requests, so I wonder if it's some io scheduler bug)
>>>
>>> Because, as we found out, without your http://lkml.org/lkml/2009/5/21/319
>>> patch read-ahead was nearly disabled, hence there were no difference
>>> which
>>> algorithm was used?
>>>
>>> Ronald, can you run the following tests, please? This time with 2 hosts,
>>> initiator (client) and target (server) connected using 1 Gbps iSCSI. It
>>> would be the best if on the client vanilla 2.6.29 will be ran, but any
>>> other
>>> kernel will be fine as well, only specify which. Blockdev-perftest should
>>> be
>>> ran as before in buffered mode, i.e. with "-a" switch.
>>>
>>> 1. All defaults on the client, on the server vanilla 2.6.29 with
>>> Fengguang's
>>> http://lkml.org/lkml/2009/5/21/319 patch with all default settings.
>>>
>>> 2. All defaults on the client, on the server vanilla 2.6.29 with
>>> Fengguang's
>>> http://lkml.org/lkml/2009/5/21/319 patch with default RA size and 64KB
>>> max_sectors_kb.
>>>
>>> 3. All defaults on the client, on the server vanilla 2.6.29 with
>>> Fengguang's
>>> http://lkml.org/lkml/2009/5/21/319 patch with 2MB RA size and default
>>> max_sectors_kb.
>>>
>>> 4. All defaults on the client, on the server vanilla 2.6.29 with
>>> Fengguang's
>>> http://lkml.org/lkml/2009/5/21/319 patch with 2MB RA size and 64KB
>>> max_sectors_kb.
>>>
>>> 5. All defaults on the client, on the server vanilla 2.6.29 with
>>> Fengguang's
>>> http://lkml.org/lkml/2009/5/21/319 patch and with context RA patch. RA
>>> size
>>> and max_sectors_kb are default. For your convenience I committed the
>>> backported context RA patches into the SCST SVN repository.
>>>
>>> 6. All defaults on the client, on the server vanilla 2.6.29 with
>>> Fengguang's
>>> http://lkml.org/lkml/2009/5/21/319 and context RA patches with default RA
>>> size and 64KB max_sectors_kb.
>>>
>>> 7. All defaults on the client, on the server vanilla 2.6.29 with
>>> Fengguang's
>>> http://lkml.org/lkml/2009/5/21/319 and context RA patches with 2MB RA
>>> size
>>> and default max_sectors_kb.
>>>
>>> 8. All defaults on the client, on the server vanilla 2.6.29 with
>>> Fengguang's
>>> http://lkml.org/lkml/2009/5/21/319 and context RA patches with 2MB RA
>>> size
>>> and 64KB max_sectors_kb.
>>>
>>> 9. On the client default RA size and 64KB max_sectors_kb. On the server
>>> vanilla 2.6.29 with Fengguang's http://lkml.org/lkml/2009/5/21/319 and
>>> context RA patches with 2MB RA size and 64KB max_sectors_kb.
>>>
>>> 10. On the client 2MB RA size and default max_sectors_kb. On the server
>>> vanilla 2.6.29 with Fengguang's http://lkml.org/lkml/2009/5/21/319 and
>>> context RA patches with 2MB RA size and 64KB max_sectors_kb.
>>>
>>> 11. On the client 2MB RA size and 64KB max_sectors_kb. On the server
>>> vanilla
>>> 2.6.29 with Fengguang's http://lkml.org/lkml/2009/5/21/319 and context RA
>>> patches with 2MB RA size and 64KB max_sectors_kb.
>>
>> Ok, done. Performance is pretty bad overall :(
>>
>> The kernels I used:
>> client kernel: 2.6.26-15lenny3 (debian)
>> server kernel: 2.6.29.5 with blk_dev_run patch
>>
>> And I adjusted the blockdev-perftest script to drop caches on both the
>> server (via ssh) and the client.
>>
>> The results:
>>

... results ...

> Those are on the server without io_context-2.6.29 and readahead-2.6.29
> patches applied and with CFQ scheduler, correct?

No. It was done with the readahead patch
(http://lkml.org/lkml/2009/5/21/319) and the context RA patch
(starting at test 5) as you requested.

> Then we see how reorder of requests caused by many I/O threads submitting
> I/O in separate I/O contexts badly affect performance and no RA, especially
> with default 128KB RA size, can solve it. Less max_sectors_kb on the client
> => more requests it sends at once => more reorder on the server => worse
> throughput. Although, Fengguang, in theory, context RA with 2MB RA size
> should considerably help it, no?

Wouldn't setting scst_threads to 1 help also in this case?

> Ronald, can you perform those tests again with both io_context-2.6.29 and
> readahead-2.6.29 patches applied on the server, please?

Ok. I only have access to the test systems during the week, so results
might not be ready before Monday. Are there tests that we can exclude
to speed things up?

Ronald.
