Return-Path: <linux-kernel-owner+w=401wt.eu-S1752800AbZF3IFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbZF3IFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 04:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbZF3IFC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 04:05:02 -0400
Received: from lucidpixels.com ([75.144.35.66]:42626 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbZF3IE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 04:04:59 -0400
Date: Tue, 30 Jun 2009 04:05:02 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: David Rientjes <rientjes@google.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Rik van Riel <riel@redhat.com>
Subject: Re: [Bug #13648] nfsd: page allocation failure
In-Reply-To: <alpine.DEB.2.00.0906291659550.17663@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0906300404210.13871@p34.internal.lan>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera> <5Hhc7UkUKEO.A.KGF.HjASKB@chimera> <alpine.DEB.2.00.0906291659550.17663@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 29 Jun 2009, David Rientjes wrote:

> On Mon, 29 Jun 2009, Rafael J. Wysocki wrote:
>
>> This message has been generated automatically as a part of a report
>> of regressions introduced between 2.6.29 and 2.6.30.
>>
>> The following bug entry is on the current list of known regressions
>> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
>> be listed and let me know (either way).
>>
>>
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13648
>> Subject		: nfsd: page allocation failure
>> Submitter	: Justin Piszcz <jpiszcz@lucidpixels.com>
>> Date		: 2009-06-22 12:08 (7 days old)
>> References	: http://lkml.org/lkml/2009/6/22/309
>>
>
> I'd be interested to hear from Justin if reducing
> /proc/sys/vm/dirty_background_ratio as I earlier suggested helps.
>
> ZONE_NORMAL isn't much larger than ZONE_DMA32 on this machine and both
> lowmem zones have an abundance of free memory which suggests pdflush's
> ratio isn't being met to commence background writeout while at the same
> time ZONE_NORMAL is being depleted as the result of constant nfs
> GFP_ATOMIC allocations that cannot try direct reclaim.
>

Hello,

http://patchwork.kernel.org/patch/30960/

"It's funny, though, that the problem that originally started this thread 
was quickly diagnosed because of these messages.  As far as I know, my 
suggestion to increase /proc/sys/vm/dirty_background_ratio to kick pdflush 
earlier has prevented the slab allocation failures and not required 
delayed acks for nfsd."

--

The current value is 10, what value do you suggest I try?

$ cat /proc/sys/vm/dirty_background_ratio
10

Justin.

