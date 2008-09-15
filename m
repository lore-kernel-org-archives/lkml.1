Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbYIOR2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbYIOR2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 13:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbYIOR2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 13:28:12 -0400
Received: from qb-out-0506.google.com ([72.14.204.231]:58099 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbYIOR2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 13:28:11 -0400
Message-ID: <f488382f0809151028w4b5b8a2bs86025e9286cfffe7@mail.gmail.com>
Date: Mon, 15 Sep 2008 10:28:09 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Bill Davidsen" <davidsen@tmr.com>
Subject: Re: [PATCH] init: bzip2 or lzma -compressed kernels and initrds
Cc: "Frans Meulenbroeks" <fransmeulenbroeks@gmail.com>,
       "Rob Landley" <rob@landley.net>, "Willy Tarreau" <w@1wt.eu>,
       "Alain Knaff" <alain@knaff.lu>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <48CE97BA.1060901@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200809062119.m86LJ5Of026101@hitchhiker.org.lu>
	 <20080907054831.GA2244@1wt.eu> <200809142037.48204.rob@landley.net>
	 <ac9c93b10809150546w7644316bk53122b0ce5021ff4@mail.gmail.com>
	 <48CE97BA.1060901@tmr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2008 at 10:13 AM, Bill Davidsen <davidsen@tmr.com> wrote:
> Frans Meulenbroeks wrote:
>>
>> 2008/9/15 Rob Landley <rob@landley.net>:
>>>
>>> On Sunday 07 September 2008 00:48:31 Willy Tarreau wrote:
>>>>
>>>> Hi Alain,
>>>>>
>>>>> +config KERNEL_LZMA
>>>>> +       bool "LZMA"
>>>>> +       help
>>>>> +         The most recent compression algorithm.
>>>>> +    Its ratio is best, decompression speed is between the other
>>>>> +    2. Compression is slowest.
>>>>> +    The kernel size is about 33 per cent smaller with lzma,
>>>>> +    in comparison to gzip.
>>>>
>>>> isn't memory usage in the same range as bzip2 ?
>>>
>>> Last I checked it was more.  (I very vaguely recall somebody saying 16
>>> megs
>>> working space back when this was first submitted to busybox, but that was
>>> a
>>> few years ago...)
>>>
>>> A quick Google found a page that benchmarks them.  Apparently it depends
>>> heavily on which compression option you use:
>>>
>>> http://tukaani.org/lzma/benchmarks
>>>
>>
>> [...]
>>
>> Apologies if I'm sidetracking the discussion, but I'd like to coin a
>> remark.
>>
>> For kernel/ramfsimage etc the best choice is the one that has the
>> fastest decompression (info on tukaani.org says gzip).
>> Rationale: as it uncompresses faster the system will boot faster.
>>
>> Of course this only holds if the background memory can hold that
>> image. For disk based systems, I assume this is not a problem at all,
>> but for embedded systems with all software in flash a higher
>> compression ration (e.g. lzma) can just make the difference between
>> fit and not fit (so in those cases lzma could just make your day).
>>
> Given the larger memory needed to decompress, it becomes a very interesting
> calculation in really small memory machines.
>

It all really depends on what you're prioritizing. If your priority is
speed and low RAM usage, you'd want to go with gzip. If your priority
is low disk usage (for instance, if you're a kernel developer with
dozens of kernels on /boot) and speed/RAM usage are less important,
LZMA is a good choice. It's just a matter of priority in non-embedded
machines. And in embedded machines, you just need to be -really-
careful about the RAM usage. LZMA is pretty flexible, though, so you
can customize the settings to get it to fit whatever memory profile
you need to.
