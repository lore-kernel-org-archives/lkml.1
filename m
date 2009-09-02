Return-Path: <linux-kernel-owner+w=401wt.eu-S1753650AbZIBWUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbZIBWUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 18:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753597AbZIBWUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 18:20:00 -0400
Received: from mail-vw0-f195.google.com ([209.85.212.195]:43474 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580AbZIBWT7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 18:19:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=m3Oi+19XfJqA/VPssvP4QXHEHw3s0vDSnqBINBUvef9ZRmlrAmtVQCiSiSgP0TKT/c
         2/PIAIqzRSeqZvO8xKTNDBLMg/itu+N9T7e89tsryk6bntenXqk6Iq3g4uvhGbhygazV
         fnVitMj8pRxx5oj+Rv2AmhNjXJkLLaiOAGnBo=
MIME-Version: 1.0
In-Reply-To: <h7mgl3$v6$1@ger.gmane.org>
References: <fb7befa20909020932k74fa9e37x1eeabdb494835bb9@mail.gmail.com>
	 <h7mgl3$v6$1@ger.gmane.org>
Date: Wed, 2 Sep 2009 18:20:00 -0400
Message-ID: <fb7befa20909021520o110b9159led09237e72da469e@mail.gmail.com>
Subject: Re: LowFree pattern
From: Adayadil Thomas <adayadil.thomas@gmail.com>
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What problem did you see that you traced to LowFree?

I have set this device as a bridge. Higher latency and low throughput seem
to be related to LowFree. There are also packet drops at the interface
when LowFree is too low.

I have another device which has 4G RAM split into 900M LowMem and
the rest as HighMem. In that case also, LowMem goes to a low level, say 8M
and although HighMem has ~2G free, the system gives OOPS (related to
page_alloc failures)
when acting as a bridge (passing packets).




On Wed, Sep 2, 2009 at 3:22 PM, Bill Davidsen<davidsen@tmr.com> wrote:
> Adayadil Thomas wrote:
>>
>> Greetings.
>>
>> I am running a centos linux with 2.6.20 version kernel. The system has
>> 1G of RAM.
>>
>> As time goes by the LowFree becomes really low. Right now it shows
>> 137M .. but it goes as low as 8M or so
>>
>> The command -
>> echo 3 > /proc/sys/vm/drop_caches
>> brings back the LowFree to way up high.
>>
>> The question I have is whether the system by itself release the cache
>> (drop cache) automatically
>> to maintain a reasonable LowFree?
>> Is this configurable?
>>
> You can change the parameters in /rpoc/sys/vm if you wish, but what makes
> you think this is needed? Cache is dropped as memory is needed, and
> drop_cache in general is a good way to slow the system.
>
>> Any information or help is much appreciated.
>>
> What problem did you see that you traced to LowFree?
>
>>
>> cat /proc/meminfo
>> MemTotal:      1034788 kB
>> MemFree:        138240 kB
>> Buffers:         99260 kB
>> Cached:         177776 kB
>> SwapCached:      51740 kB
>> Active:         605172 kB
>> Inactive:       113572 kB
>> HighTotal:      130720 kB
>> HighFree:          252 kB
>> LowTotal:       904068 kB
>> LowFree:        137988 kB
>> SwapTotal:     1048568 kB
>> SwapFree:       976332 kB
>> Dirty:             380 kB
>> Writeback:           0 kB
>> AnonPages:      441348 kB
>> Mapped:          15540 kB
>> Slab:           146088 kB
>> SReclaimable:   104288 kB
>> SUnreclaim:      41800 kB
>> PageTables:       1596 kB
>> NFS_Unstable:        0 kB
>> Bounce:              0 kB
>> CommitLimit:   1565960 kB
>> Committed_AS:   590576 kB
>> VmallocTotal:   114680 kB
>> VmallocUsed:     15052 kB
>> VmallocChunk:    99348 kB
>
>
> --
> Bill Davidsen <davidsen@tmr.com>
>  "We have more to fear from the bungling of the incompetent than from
> the machinations of the wicked."  - from Slashdot
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
