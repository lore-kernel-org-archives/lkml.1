Return-Path: <linux-kernel-owner+w=401wt.eu-S1753738AbXFLVbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738AbXFLVbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 17:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbXFLVbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 17:31:45 -0400
Received: from lucidpixels.com ([75.144.35.66]:55979 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747AbXFLVbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 17:31:44 -0400
Date: Tue, 12 Jun 2007 17:31:44 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Pavel Machek <pavel@ucw.cz>
cc: Jesse Barnes <jesse.barnes@intel.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
In-Reply-To: <20070612213020.GA13747@elf.ucw.cz>
Message-ID: <Pine.LNX.4.64.0706121731250.7526@p34.internal.lan>
References: <200706071530.51552.jesse.barnes@intel.com> <20070612145007.GA5986@ucw.cz>
 <200706120829.21465.jesse.barnes@intel.com> <20070612213020.GA13747@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Jun 2007, Pavel Machek wrote:

> Hi!
>
>>>> On some machines, buggy BIOSes don't properly setup WB MTRRs to
>>>> cover all available RAM, meaning the last few megs (or even gigs)
>>>> of memory will be marked uncached.  Since Linux tends to allocate
>>>> from high memory addresses first, this causes the machine to be
>>>> unusably slow as soon as the kernel starts really using memory
>>>> (i.e. right around init time).
>>>>
>>>> +	if ((highest_addr >> PAGE_SHIFT) != end_pfn) {
>>>> +		printk(KERN_WARNING "***************\n");
>>>> +		printk(KERN_WARNING "**** WARNING: likely BIOS bug\n");
>>>> +		printk(KERN_WARNING "**** MTRRs don't cover all of "
>>>> +		       "memory, trimmed %ld pages\n", end_pfn -
>>>> +		       (highest_addr >> PAGE_SHIFT));
>>>> +		printk(KERN_WARNING "***************\n");
>>>> +		end_pfn = highest_addr >> PAGE_SHIFT;
>>>
>>> Missing 4K of memory is not worth 4K of junk in syslog per boot. Can
>>> you drop the stars and stop shouting?
>>
>> How missing about 1G of memory?  We already discussed this, and Andi and
>> Venki felt that either a panic or a really obnoxious message was the
>> way to go...
>
> Just use panic, then.
> 									Pavel,
> 	who still thinks anyone missing 1GB of ram will not miss
> 	friendly notice in dmesg, even if it goes without 20 stars.
>
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>

What is wrong with Jesse's patch?  I've been using it for quite a few days 
now, no issues.

Justin.
