Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbZJ1GBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbZJ1GBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 02:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756753AbZJ1GBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 02:01:21 -0400
Received: from nskntmtas03p.mx.bigpond.com ([61.9.168.143]:36791 "EHLO
	nskntmtas03p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756752AbZJ1GBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 02:01:20 -0400
Message-ID: <4AE7DE32.1050001@bigpond.net.au>
Date: Wed, 28 Oct 2009 16:01:22 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Pankaj Parakh <me.pankajparakh@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       XingChao Wang <wxc200@gmail.com>
Subject: Re: How to add scheduler
References: <27a8ee1b0910100017h75579306i42463e309bd26712@mail.gmail.com>	 <27a8ee1b0910100018g1207c5b1uf742677b55f2f99b@mail.gmail.com>	 <4AD27044.7030907@bigpond.net.au>	 <27a8ee1b0910230810x255702eepa17734514cbf525f@mail.gmail.com>	 <4AE24C2E.70208@bigpond.net.au> <27a8ee1b0910270030k555d1201if6a3f6f0576580df@mail.gmail.com>
In-Reply-To: <27a8ee1b0910270030k555d1201if6a3f6f0576580df@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at nskntotgx03p.mx.bigpond.com from [58.169.167.147] using ID pwil3058@bigpond.net.au at Wed, 28 Oct 2009 06:01:23 +0000
X-RPD-ScanID: Class unknown; VirusThreatLevel unknown, RefID str=0001.0A150204.4AE7DE33.0130,ss=1,fgs=0
X-SIH-MSG-ID: qB41EdPuHEetmGd63m2VY14jglO69W91tNsMCpZ0rBIGTUDKp8DYRNSid6RRptuyxEEfcgqHNnEgZabkXIXTtsmyIbxYYA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/10/09 17:30, Pankaj Parakh wrote:
> On Sat, Oct 24, 2009 at 6:07 AM, Peter Williams<pwil3058@bigpond.net.au>  wrote:
>> On 24/10/09 01:10, Pankaj Parakh wrote:
>>>
>>> Hi Peter,
>>>
>>> Thanks for showing your interest, I am student and I am working on a
>>> project similar to yours i.e. to have a facility where in one can swap
>>> scheduler in run-time, but I am in very initial state of learning so I
>>> wanted to try a simple RR scheduler, objective of doing it is to learn
>>> about different interfaces in modular design(introduced from 2.6.23
>>> with CFS). I do not have any constraint with version of linux. I am
>>> ready to take part with you provided you do not have any issue.
>>
>> No.  That's good.
>>
>> I've attached two patches which contain the work I've done so far.  They
>> should be applied in the following order:
>>
>> define_prelim_cpu_pisch_drv.patch
>> implement_spbrr_cpu_pisch_dvr.patch
>>
>> and will result in two schedulers: the default CFS 'fair' (cfs_fair)
>> scheduler and a simple priority based round robin (spbrr) scheduler; being
>> available for selection at boot time and run time.
>>
>> To select a scheduler at boot time just add 'cpu_pisch=cfs_fair' or
>> 'cpu_pisch=spbrr' to the boot command line.
>>
>> To select a scheduler at run time (as root) do:
>>
>> echo -n 'cfs_fair'>  /sys/kernel/cpu_pisch/name
>>
>> or
>>
>> echo -n 'spbrr'>  /sys/kernel/cpu_pisch/name
>>
>> The first step in adding your own scheduler would be to make a copy of the
>> file kernel/cpu_pisch_spbrr.c and then modify it.  You will also need to
>> modify:
>>
>> kernel/sched.c
>> kernel/cpu_pisch_drv.c
>> kernel/Kconfig.cpu_pisch
>>
>> Hopefully, the required changes are obvious.  If not don't hesitate to ask
>> questions.  Also if you feel the need to modify the scheduler interface
>> (defined in include/linux/cpu_pisch_drv.h) feel free BUT think very
>> carefully about it and try not to make things too complex.
>>
>> I am working on another scheduler (a simple entitlement based round robin
>> (sebrr) scheduler) which I hope to have finished before I publicly release
>> the patches.
>>
>> If you wish to have your scheduler included just send it to me as a patch
>> which applies on top of the ones that I've attached.
>>
>> Cheers
>> Peter
>> --
>> Peter Williams                                   pwil3058@bigpond.net.au
>>
>> "Learning, n. The kind of ignorance distinguishing the studious."
>>   -- Ambrose Bierce
>>
>
> Hi Peter,
>
> To which version of Linux Kernel should I apply the given patch.
>
>

Those patches were against 2.6.32-rc5 but they may also apply cleanly to 
later versions.

-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
