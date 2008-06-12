Return-Path: <linux-kernel-owner+w=401wt.eu-S1757173AbYFLSEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbYFLSEJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 14:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbYFLSD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 14:03:56 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:18385 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbYFLSD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 14:03:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lLORDJbB63A5Dqbre6z+fcQDYb1Lw6O5almcAC4fJBS7wQSi8JSswJZe+FU1Ej2z6H
         Ju/s3ye70XnXlH2QvjQ0XX9KpywzbdpWVtsBoKxWNxBzaHQ5M8WVF0qVij4M2LZY9Sm7
         jOiarUALFNRGimwOxGHiBvN0FcmoWWpB4lT9s=
Message-ID: <1ba2fa240806121103m60a8ffa4ie11850fedc69d13c@mail.gmail.com>
Date: Thu, 12 Jun 2008 21:03:46 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Problem: Out of memory after 2days with 2GB RAM
Cc: "Rik van Riel" <riel@redhat.com>,
       "Zdenek Kabelac" <zdenek.kabelac@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org
In-Reply-To: <1213292812.3730.21.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110806120307n20cce692s9c136f11596f5ab0@mail.gmail.com>
	 <20080612093833.0fb9cdd6@bree.surriel.com>
	 <1213278884.3936.15.camel@johannes.berg>
	 <1ba2fa240806120843s268b2ff4mb45a11adf11afc7f@mail.gmail.com>
	 <1ba2fa240806120935r54a080eci7fa6fafc718eed17@mail.gmail.com>
	 <1213290335.3730.4.camel@johannes.berg>
	 <1ba2fa240806121039o376b0a8sdfaacf3a1f4a9e57@mail.gmail.com>
	 <1213292812.3730.21.camel@johannes.berg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 8:46 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> > Well, I disagree, and I'll push my patch as soon as somebody confirms
>> > that it doesn't break anything.
>>
>> Remember you are not a maintainer of this driver and second we are
>> open to all suggestions you don't have to use this kind of
>> statements...
>
> Yeah, you're right, I can't really do that. But I can submit the patch
> to akpm, and I'm sure he'll take it after you provide your counter
> argument about hope never dying again ;)

Here you go again

> Frankly, I don't see why you're so opposed to this patch even if it
> doesn't solve anything it probably leads to better code generation and
> using a lot less memory.

I'm not against it. You;v decided that I'm fighting you because I gave
another solution.
Frankly we probably don't need this allocation at all. maybe one skb
is just enough
even with my never dying hope all fragments are in skb fragment list.
This still probably won't save pci memory allocation problem

Tomas


> Also, I know you cannot actually need those descriptors since mac80211
> will never ever pass such frames, and _that_ is an area I do have at
> least some influence over, so I'll surely notice when that changes.
>
>> >> > There was already discussion on LKML about memory allocation problems
>> >> > on X86_64, which might explain this regression. This didn't happen
>> >> > before.
>> >>
>> >> This is  the thread title if you are interested.
>> >> 'x86/kernel/pci_dma.c: gfp |= __GFP_NORETRY'
>> >
>> > Like I said, it doesn't matter, there's no need to _waste_
>> > 18*256*sizeof(void *) bytes memory.
>>
>> It does matter this is not pci allocation we are saving in your patch.
>
> Well, thing is, my patch saves 18 KiB memory on 32-bit and 36 on 64-bit,
> so I think we should merge it regardless. Yes, the pci allocation is
> icky, and yes, it would be good to just do it once instead of over and
> over again, but even if you change it to do _all_ those allocations just
> once we should not be wasting those 18/36 KiB memory for nothing.
>
> johannes
>
