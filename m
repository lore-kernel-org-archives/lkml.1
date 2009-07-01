Return-Path: <linux-kernel-owner+w=401wt.eu-S1753059AbZGANHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbZGANHj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 09:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbZGANHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 09:07:32 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:56124 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbZGANHb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 09:07:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oluWn/jkSm+FRG95A3s6hO6cCTMubahfjnug16hAAa1Nf5W0KUJvK9de0J/aFZ2OrO
         K1nReelePGD5dtalDhWvlu9byzOSIBimnztbWZFGA7Sxb8kwf5/8zYAjYpVPF8jrf6+y
         wfqh3M1GxmbP5bxwFU+igWtnqeKdjFozKYdGo=
MIME-Version: 1.0
In-Reply-To: <4A49EEF9.6010205@vlnb.net>
References: <4A3CD62B.1020407@vlnb.net> <4A489DAC.7000007@vlnb.net>
	 <20090629125434.GA8416@localhost> <4A48BBF9.6050408@vlnb.net>
	 <a0272b440906290700v7367d1c1r7237fd6593be00d2@mail.gmail.com>
	 <20090629142124.GA28945@localhost> <20090629150109.GA3534@localhost>
	 <4A48DFC5.3090205@vlnb.net> <20090630010414.GB31418@localhost>
	 <4A49EEF9.6010205@vlnb.net>
Date: Wed, 1 Jul 2009 15:07:32 +0200
Message-ID: <a0272b440907010607g4c0d0c7fk3ad9659319230a4d@mail.gmail.com>
Subject: Re: [RESEND] [PATCH] readahead:add blk_run_backing_dev
From: Ronald Moesbergen <intercommit@gmail.com>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/30 Vladislav Bolkhovitin <vst@vlnb.net>:
> Wu Fengguang, on 06/30/2009 05:04 AM wrote:
>>
>> On Mon, Jun 29, 2009 at 11:37:41PM +0800, Vladislav Bolkhovitin wrote:
>>>
>>> Wu Fengguang, on 06/29/2009 07:01 PM wrote:
>>>>
>>>> On Mon, Jun 29, 2009 at 10:21:24PM +0800, Wu Fengguang wrote:
>>>>>
>>>>> On Mon, Jun 29, 2009 at 10:00:20PM +0800, Ronald Moesbergen wrote:
>>>>>>
>>>>>> ... tests ...
>>>>>>
>>>>>>> We started with 2.6.29, so why not complete with it (to save
>>>>>>> additional
>>>>>>> Ronald's effort to move on 2.6.30)?
>>>>>>>
>>>>>>>>> 2. Default vanilla 2.6.29 kernel, 512 KB read-ahead, the rest is
>>>>>>>>> default
>>>>>>>>
>>>>>>>> How about 2MB RAID readahead size? That transforms into about 512KB
>>>>>>>> per-disk readahead size.
>>>>>>>
>>>>>>> OK. Ronald, can you 4 more test cases, please:
>>>>>>>
>>>>>>> 7. Default vanilla 2.6.29 kernel, 2MB read-ahead, the rest is default
>>>>>>>
>>>>>>> 8. Default vanilla 2.6.29 kernel, 2MB read-ahead, 64 KB
>>>>>>> max_sectors_kb, the rest is default
>>>>>>>
>>>>>>> 9. Patched by the Fengguang's patch vanilla 2.6.29 kernel, 2MB
>>>>>>> read-ahead, the rest is default
>>>>>>>
>>>>>>> 10. Patched by the Fengguang's patch vanilla 2.6.29 kernel, 2MB
>>>>>>> read-ahead, 64 KB max_sectors_kb, the rest is default
>>>>>>
>>>>>> The results:
>>>>>
>>>>> I made a blindless average:
>>>>>
>>>>> N       MB/s          IOPS      case
>>>>>
>>>>> 0      114.859       984.148    Unpatched, 128KB readahead, 512
>>>>> max_sectors_kb
>>>>> 1      122.960       981.213    Unpatched, 512KB readahead, 512
>>>>> max_sectors_kb
>>>>> 2      120.709       985.111    Unpatched, 2MB readahead, 512
>>>>> max_sectors_kb
>>>>> 3      158.732      1004.714    Unpatched, 512KB readahead, 64
>>>>> max_sectors_kb
>>>>> 4      159.237       979.659    Unpatched, 2MB readahead, 64
>>>>> max_sectors_kb
>>>>>
>>>>> 5      114.583       982.998    Patched, 128KB readahead, 512
>>>>> max_sectors_kb
>>>>> 6      124.902       987.523    Patched, 512KB readahead, 512
>>>>> max_sectors_kb
>>>>> 7      127.373       984.848    Patched, 2MB readahead, 512
>>>>> max_sectors_kb
>>>>> 8      161.218       986.698    Patched, 512KB readahead, 64
>>>>> max_sectors_kb
>>>>> 9      163.908       574.651    Patched, 2MB readahead, 64
>>>>> max_sectors_kb
>>>>>
>>>>> So before/after patch:
>>>>>
>>>>>        avg throughput      135.299 => 138.397  by +2.3%
>>>>>        avg IOPS            986.969 => 903.344  by -8.5%
>>>>>
>>>>> The IOPS is a bit weird.
>>>>>
>>>>> Summaries:
>>>>> - this patch improves RAID throughput by +2.3% on average
>>>>> - after this patch, 2MB readahead performs slightly better
>>>>>  (by 1-2%) than 512KB readahead
>>>>
>>>> and the most important one:
>>>> - 64 max_sectors_kb performs much better than 256 max_sectors_kb, by
>>>> ~30% !
>>>
>>> Yes, I've just wanted to point it out ;)
>>
>> OK, now I tend to agree on decreasing max_sectors_kb and increasing
>> read_ahead_kb. But before actually trying to push that idea I'd like
>> to
>> - do more benchmarks
>> - figure out why context readahead didn't help SCST performance
>>  (previous traces show that context readahead is submitting perfect
>>   large io requests, so I wonder if it's some io scheduler bug)
>
> Because, as we found out, without your http://lkml.org/lkml/2009/5/21/319
> patch read-ahead was nearly disabled, hence there were no difference which
> algorithm was used?
>
> Ronald, can you run the following tests, please? This time with 2 hosts,
> initiator (client) and target (server) connected using 1 Gbps iSCSI. It
> would be the best if on the client vanilla 2.6.29 will be ran, but any other
> kernel will be fine as well, only specify which. Blockdev-perftest should be
> ran as before in buffered mode, i.e. with "-a" switch.

I could, but: only the first 'dd' run of blockdev-perftest will have
any value, since all others will be served from the target's cache,
won't that make the results pretty much useless (?). Are you sure this
is what you want me to test?

Ronald.
