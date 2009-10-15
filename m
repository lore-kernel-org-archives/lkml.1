Return-Path: <linux-kernel-owner+w=401wt.eu-S1762940AbZJOTjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762940AbZJOTjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 15:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755267AbZJOTjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 15:39:17 -0400
Received: from mail.lang.hm ([64.81.33.126]:35002 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316AbZJOTjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 15:39:17 -0400
Date: Thu, 15 Oct 2009 12:38:09 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Ingo Molnar <mingo@elte.hu>
cc: Greg KH <gregkh@suse.de>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: removing existing working drivers via staging
In-Reply-To: <20091015191641.GB19467@elte.hu>
Message-ID: <alpine.DEB.2.00.0910151230560.22169@asgard.lang.hm>
References: <alpine.DEB.2.00.0910142213590.22169@asgard.lang.hm> <200910151942.40259.bzolnier@gmail.com> <20091015174932.GA3595@suse.de> <200910152020.13080.bzolnier@gmail.com> <20091015184656.GA29858@suse.de> <alpine.DEB.2.00.0910151200100.22169@asgard.lang.hm>
 <20091015191641.GB19467@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009, Ingo Molnar wrote:

> * david@lang.hm <david@lang.hm> wrote:
>
>>> But a driver in staging still has to be able to build, api changes
>>> are not able to be ignored in it.
>>
>> a driver in staging will be able to build, but a driver that was
>> removed after 6-9 months that a user discovered the removal of a year
>> later when they upgraded to a new distro release (say a normal ubuntu
>> release after staying on the old one for the 18 month support period)
>> is likely to need significant work to catch up with kernel changes in
>> the meanwhile.
>
> Where do you get the 6-9 months from? Greg said he'll wait 3 kernel
> releases. Here's the timeline of that:

that was the timeframe listed in the prior discussion, 3 kernel releases * 
2-3 months/release works out to this

> - release x
> - [A] driver moves into drivers/staging/ in the staging tree
> - release x+1
> - drivers/staging/ change gets merged in the x+2 merge window
> - release x+2 - first kernel with the driver in staging
> - release x+3
> - release x+4
> - driver gets removed in the staging tree
> - release x+5 - 3 kernel releases passed - now it's removed
> - removal propagates upstream in the x+6 merge window
> - [B] release x+6

I would have seen this as

release x
driver moves into staging
release x+1
release x+2
release x+3
driver is removed
release x+4 no longer has the driver

> from the decision to move it into staging there's 4 kernel releases
> during which the information is known, and 3 full kernel releases with
> the driver is actually moved, and even in the 4th cycle there's still 3
> months to undo the removal if there's objections (i.e. it's a
> regression).
>
> This means the timeline is 4*3 = 12 months _at minimum_. In practice it
> will be more than a year - up to 1.5 years. Well within most distros ~3
> months upstream kernel update schedule.

yes, this is well past the distro update cycle for new releases, but not 
within the user update cycle. there are a LOT of people who don't upgrade 
every 6 months. every distro provides support for at least 12 months, if 
not more. and even then there are a lot of people who drop out of their 
distro support before they upgrade.

it's these users who will discover the missing driver and care about it, 
not the distros.

personally, I try to do a kernel update every year (if security concerns 
in a feature that I have compiled in don't force me to upgrade sooner) 
sometimes with a distro upgrade, sometimes not.

David Lang
