Return-Path: <linux-kernel-owner+w=401wt.eu-S1762450AbZFNAtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762450AbZFNAtA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 20:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbZFNAsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 20:48:52 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:40237 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbZFNAsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 20:48:52 -0400
X-IronPort-AV: E=Sophos;i="4.42,215,1243828800"; 
   d="scan'208";a="2545515"
Message-ID: <4A344782.2090707@analog.com>
Date: Sun, 14 Jun 2009 08:42:42 +0800
From: Jie Zhang <jie.zhang@analog.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Jamie Lokier <jamie@shareable.org>,
       uClinux development list <uclinux-dev@uclinux.org>,
       linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       David McCullough <davidm@snapgear.com>
Subject: Re: [uClinux-dev] [PATCH/RFC] FDPIC: add hook for arches to customize
 	program header parsing
References: <1244854869-2563-1-git-send-email-vapier@gentoo.org> 	<20090613161323.GC16220@shareable.org> <8bd0f97a0906130940j6b5e578bha8193f59d03c2f05@mail.gmail.com> 	<20090613182540.GJ16220@shareable.org> <8bd0f97a0906131732v5394eaf5gb0f7862dfe7f58f3@mail.gmail.com>
In-Reply-To: <8bd0f97a0906131732v5394eaf5gb0f7862dfe7f58f3@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jun 2009 00:42:54.0015 (UTC) FILETIME=[0DA1C4F0:01C9EC89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> On Sat, Jun 13, 2009 at 14:25, Jamie Lokier wrote:
>> Mike Frysinger wrote:
>>> On Sat, Jun 13, 2009 at 12:13, Jamie Lokier wrote:
>>>> Mike Frysinger wrote:
>>>>> From: Jie Zhang <jie.zhang@analog.com>
>>>>>
>>>>> The Blackfin port has custom program header flags/addresses for
>>>>> automatically loading regions into the dedicated on-chip SRAM.  So add a
>>>>> hook for ports to leverage.
>>>> It looks like a way for certain special executables to load themselves
>>>> into fixed regions of the on-chip SRAM - and promptly crash if another
>>>> executable does the same.  Not so much a general executable format, as
>>>> a hack to load something specific which should only be done once at a
>>>> time.  What am I missing here?
>>> the addresses are keys, not fixed and/or "real" addresses
>> Oh, I see that is indeed quite nice :-)
>>
>> I see it checks for both flags and special address values.  Are the
>> special address checks mainly historical, as usually flags/types are
>> used to designate special memory types in ELF.
> 
> the EF bits are more for smaller/statically linked applications where
> you want to place the entire ELF into SRAM.  the special PHDRs are for
> selectively compiled code -- i.e. you've done a little bit of
> profiling and testing and know which ones are the hot spots.

Yes. Those e_flags works for the whole ELF file. And these specific 
addresses work as p_flags. May be in future I can add processor specific 
p_flags.


Jie


