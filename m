Return-Path: <linux-kernel-owner+w=401wt.eu-S1755651AbYFLRgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651AbYFLRgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 13:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbYFLRfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 13:35:50 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:26463 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbYFLRft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 13:35:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QXgzqZyY/zmMWIr8JGS8e+ApzF7LJdEJZaS0hh8BGr84jY6dx8uwgOXeqXh0Xqay3z
         PcHZu09dgWX/8NJLr08VFqI3xu3W4Jnc8+LV74JWxdVyzjtoNzejSP5/2hwKXHFbxh6l
         aUkl2frtDYGaOtEaHJBl1xqtoZ63XjeYrujOA=
Message-ID: <1ba2fa240806121035t40d3e8c4laccc768ae337075d@mail.gmail.com>
Date: Thu, 12 Jun 2008 20:35:48 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Problem: Out of memory after 2days with 2GB RAM
Cc: "Rik van Riel" <riel@redhat.com>,
       "Zdenek Kabelac" <zdenek.kabelac@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org
In-Reply-To: <1213290205.3730.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110806120307n20cce692s9c136f11596f5ab0@mail.gmail.com>
	 <20080612093833.0fb9cdd6@bree.surriel.com>
	 <1213278884.3936.15.camel@johannes.berg>
	 <1ba2fa240806120843s268b2ff4mb45a11adf11afc7f@mail.gmail.com>
	 <1213290205.3730.2.camel@johannes.berg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 8:03 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> > Try the patch below. It should improve code generation too.
>> >
>> > I discussed this with Tomas previously and he says the hw is capable of
>> > doing 20 fragments per frame (wonder why, Broadcom can do an unlimited
>> > number...) but he complained about the networking stack not being able
>> > to.
>>
>> This is scatter gather buffers that can be kicked in one DMA transaction.
>>
>> Well, the hardware needs to support IP checksumming for that, hence,
>> > afaik, only two fragments can ever be used (one for hw header, one for
>> > frame)
>> This I still don't understand why but everybody is already tired to
>> explaining me why.. :) Just need to find time to dig into it.
>
> And you can safely decrease the allocation to 10% as I do in my patch
> because once you understand you'll see that you cannot possibly use
> more. Hence, you can ack this patch ;)
>
>> > This cuts the allocation to 10%, or (under) a page in all cases.
>>
>> Probably. it would be safe to use vmalloc for allocating txb anyway.
>> I'll give it a try.
>
> Yeah, but why bother if we can just allocate 10% of the size, waste a
> lot less memory etc. mac80211 isn't going to pass in a scatter/gather
> frame anyway.

Hope never dies. I actually have seen this speed up the throughput so
I will dig into it anyway.

>> There was already discussion on LKML about memory allocation problems
>> on X86_64, which might explain this regression. This didn't happen
>> before.
>
> Doesn't really matter, iwlwifi is _wasting_ this allocation, it cannot
> possibly use all those buffers anyway.

This matter actually for consistent allocation.

> The more interesting thing is the pci_alloc_consistent allocation right
> below that is also _huge_, but that's because of the stupid hardware
> design, or can the hardware cope with having the descriptors non-linear
> in memory?

We talk after your next HW design. How will configure 265 * 16
descriptors separately.

Tomas
