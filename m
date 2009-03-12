Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbZCLIsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbZCLIsz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 04:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbZCLIsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 04:48:45 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:38066 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbZCLIso convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 04:48:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=u+9nIIxX8Fkeei/EEuOo927WE92MR5GAM99VbiN5MOhySo8lM9KpqEamtTSIAo4b76
         s0t6GF/AtjOVJlZv05cSVThWQeprlM+T1b3+IdmXqnjyykEfLUljMAaZdjnMjiSUWz7L
         zEnQP1AVaWXRwBVBcLbiNn4Xw46sJTjqzDWf0=
MIME-Version: 1.0
In-Reply-To: <20090312081113.GA19506@localhost>
References: <e2dc2c680903110341g6c9644b8j87ce3b364807e37f@mail.gmail.com>
	 <20090311114353.GA759@localhost>
	 <e2dc2c680903110451m3cfa35d9s7a9fd942bcee39eb@mail.gmail.com>
	 <20090311121123.GA7656@localhost>
	 <e2dc2c680903110516v2c66d4a4h6a422cffceb12e2@mail.gmail.com>
	 <20090311122611.GA8804@localhost>
	 <e2dc2c680903120053w37968c1cy556812cef63f0896@mail.gmail.com>
	 <20090312075952.GA19331@localhost>
	 <e2dc2c680903120104h4d19a3f6j57ad045bc06f9a90@mail.gmail.com>
	 <20090312081113.GA19506@localhost>
Date: Thu, 12 Mar 2009 09:48:42 +0100
Message-ID: <e2dc2c680903120148j1aee0759td49055be059e33ae@mail.gmail.com>
Subject: Re: Memory usage per memory zone
From: jack marrow <jackmarrow2@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Didn't reply all:)

2009/3/12 Wu Fengguang <fengguang.wu@intel.com>:
> On Thu, Mar 12, 2009 at 10:04:17AM +0200, jack marrow wrote:
>> 2009/3/12 Wu Fengguang <fengguang.wu@intel.com>:
>> > On Thu, Mar 12, 2009 at 09:53:27AM +0200, jack marrow wrote:
>> >> > Can you paste /proc/vmstat, /proc/meminfo, /proc/zoneinfo and
>> >> > /proc/slabinfo? Thank you.
>> >>
>> >> Sure, but I don't know if it will help.
>> >>
>> >> The oom info was from in the night, the rest is from now. I have no zoneinfo.
>> >>
>> >> http://pastebin.com/m67409bc0
>> >
>> > Thank you! So you are running a pretty old kernel?
>> >
>>
>> Yes. Kernel.2.6.9-78.
>>
>> Added more output from the other oom kills here:
>>  http://pastebin.com/m76fc473d
>>
>> If I could just find a way to find out what is using up all the memory
>> in a zone I could go away happy :)
>
> But the highmem zone wont help you much, since you have a large 900M
> normal zone and a tiny 100M highmem zone ;)
>
> The cached files seem to be the memory killer:

I ran an echo 3 > drop_caches yesterday, I was hoping to come in and
find no oom kill. Oh well :)

I thought the kernel dropped caches if a program needs the ram?

>
> MemTotal:      1034496 kB
> MemFree:         95600 kB
> Buffers:         49916 kB
> Cached:         761544 kB
> SwapCached:          0 kB
> Active:          80484 kB
> Inactive:       749960 kB
> HighTotal:      131008 kB
> HighFree:        68480 kB
> LowTotal:       903488 kB
> LowFree:         27120 kB
> SwapTotal:     2040212 kB
> SwapFree:      2039780 kB
> Dirty:               4 kB
> Writeback:           0 kB
> Mapped:          32636 kB
> Slab:            93856 kB
> CommitLimit:   2557460 kB
> Committed_AS:   129980 kB
> PageTables:       1800 kB
> VmallocTotal:   106488 kB
> VmallocUsed:      3372 kB
> VmallocChunk:   102616 kB
> HugePages_Total:     0
> HugePages_Free:      0
> Hugepagesize:     2048 kB
>
> Is upgrading the kernel an option for you?

No :(

I think shoving some more ram in the box is the best doable option.
Would this help here?

To do that I need to say "look at how much cache we are using for
files, that cache is in the high mem zone (look here) so let's put
some more ram in". Does the cache always live in the high mem zone?

>
> Thanks,
> Fengguang
