Return-Path: <linux-kernel-owner+w=401wt.eu-S932615AbXGMGdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615AbXGMGdQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 02:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754189AbXGMGdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 02:33:03 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:35220
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbXGMGdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 02:33:01 -0400
Date: Thu, 12 Jul 2007 23:27:41 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Joseph Fannin <jfannin@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: Hibernating To Swap Considered Harmful
In-Reply-To: <20070713062039.GA29055@nineveh.local>
Message-ID: <Pine.LNX.4.64.0707122319270.25614@asgard.lang.hm>
References: <1184167831.12556.13.camel@caritas-dev.intel.com>
 <200707121453.49616.rjw@sisk.pl> <Pine.LNX.4.64.0707121150460.25614@asgard.lang.hm>
 <200707122134.29991.rjw@sisk.pl> <Pine.LNX.4.64.0707121953440.25614@asgard.lang.hm>
 <20070713054244.GA20082@nineveh.local> <Pine.LNX.4.64.0707122250170.25614@asgard.lang.hm>
 <20070713062039.GA29055@nineveh.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007, Joseph Fannin wrote:

> On Thu, Jul 12, 2007 at 10:57:04PM -0700, david@lang.hm wrote:
>> On Fri, 13 Jul 2007, Joseph Fannin wrote:
>>
>> the only justification I have heard for why the hibernate image must be
>> written to the swap partition is backwards compatibility (i.e., we've
>> always done it that way)
>>
>> if you are going to reserve disk space for hibernation, what is so bad
>> about useing a normal partition?
>>
>    You have to either repartition when you upgrade your memory, or
> waste a bunch of disk space with a partition as large as you think
> your RAM might ever expand to.

memory upgrades are rare and tools are available nowdays to resize linux 
partitions.

>    Swap/hibernate files can be created, deleted, and resized without
> partitioning.

if you just use the hibernate file as a reserved set of blocks and never 
touch them from the main OS things will work, but if you do anything that 
could put those blocks into the OS write cache all bets are off.

>    Also: not all platforms support a large number of partitions.
> It's not academic -- Intel Macintoshes are limited to four, with two
> taken by Mac OS.  Add Windows and a Linux /, and you're out --
> there's no room for a swap file.

interesting, I didn't know that. I know that the Tivo's use Mac style 
partition tables and they have many partitions (10+). it seems odd that 
when switching from powerpc to x86 that they would lock themselves down 
like that. are you sure that they can't have extended partitions like 
standard PC's? it seems odd that they would have such a special partition 
table type if windows can access it.

David Lang
