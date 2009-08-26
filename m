Return-Path: <linux-kernel-owner+w=401wt.eu-S932603AbZHZA3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603AbZHZA3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 20:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755937AbZHZA3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 20:29:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753820AbZHZA3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 20:29:16 -0400
Message-ID: <4A9481BE.1030308@redhat.com>
Date: Tue, 25 Aug 2009 20:28:46 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: david@lang.hm, Theodore Tso <tytso@mit.edu>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [patch] document flash/RAID dangers
References: <20090825094244.GC15563@elf.ucw.cz> <20090825161110.GP17684@mit.edu> <20090825222112.GB4300@elf.ucw.cz> <alpine.DEB.2.00.0908251526290.28411@asgard.lang.hm> <20090825224004.GD4300@elf.ucw.cz> <alpine.DEB.2.00.0908251547520.28411@asgard.lang.hm> <20090825233701.GH4300@elf.ucw.cz> <4A947839.4010601@redhat.com> <20090826000657.GK4300@elf.ucw.cz> <4A947E05.8070406@redhat.com> <20090826002045.GO4300@elf.ucw.cz>
In-Reply-To: <20090826002045.GO4300@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2009 08:20 PM, Pavel Machek wrote:
>>>>> ---
>>>>> There are storage devices that high highly undesirable properties
>>>>> when they are disconnected or suffer power failures while writes are
>>>>> in progress; such devices include flash devices and MD RAID 4/5/6
>>>>> arrays.  These devices have the property of potentially
>>>>> corrupting blocks being written at the time of the power failure, and
>>>>> worse yet, amplifying the region where blocks are corrupted such that
>>>>> additional sectors are also damaged during the power failure.
>>>>
>>>> I would strike the entire mention of MD devices since it is your
>>>> assertion, not a proven fact. You will cause more data loss from common
>>>
>>> That actually is a fact. That's how MD RAID 5 is designed. And btw
>>> those are originaly Ted's words.
>>
>> Ted did not design MD RAID5.
>
> So what? He clearly knows how it works.
>
> Instead of arguing he's wrong, will you simply label everything as
> unproven?
>
>>>> events (single sector errors, complete drive failure) by steering people
>>>> away from more reliable storage configurations because of a really rare
>>>> edge case (power failure during split write to two raid members while
>>>> doing a RAID rebuild).
>>>
>>> I'm not sure what's rare about power failures. Unlike single sector
>>> errors, my machine actually has a button that produces exactly that
>>> event. Running degraded raid5 arrays for extended periods may be
>>> slightly unusual configuration, but I suspect people should just do
>>> that for testing. (And from the discussion, people seem to think that
>>> degraded raid5 is equivalent to raid0).
>>
>> Power failures after a full drive failure with a split write during a rebuild?
>
> Look, I don't need full drive failure for this to happen. I can just
> remove one disk from array. I don't need power failure, I can just
> press the power button. I don't even need to rebuild anything, I can
> just write to degraded array.
>
> Given that all events are under my control, statistics make little
> sense here.
> 								Pavel
>

You are deliberately causing a double failure - pressing the power button after 
pulling a drive is exactly that scenario.

Pull your single (non-MD5) disk out while writing (hot unplug from the S-ATA 
side, leaving power on) and run some tests to verify your assertions...

ric

