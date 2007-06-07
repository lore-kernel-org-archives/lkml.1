Return-Path: <linux-kernel-owner+w=401wt.eu-S1765973AbXFGRlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765973AbXFGRlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 13:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758480AbXFGRk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 13:40:57 -0400
Received: from lucidpixels.com ([75.144.35.66]:60428 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702AbXFGRk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 13:40:57 -0400
Date: Thu, 7 Jun 2007 13:40:55 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Jesse Barnes <jesse.barnes@intel.com>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
In-Reply-To: <200706071035.18356.jesse.barnes@intel.com>
Message-ID: <Pine.LNX.4.64.0706071340380.2477@p34.internal.lan>
References: <200706061229.24486.jesse.barnes@intel.com>
 <20070607081619.GA15226@one.firstfloor.org> <200706071035.18356.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Jun 2007, Jesse Barnes wrote:

> On Thursday, June 7, 2007 1:16 am Andi Kleen wrote:
>> On Wed, Jun 06, 2007 at 12:29:23PM -0700, Jesse Barnes wrote:
>>> On some machines, buggy BIOSes don't properly setup WB MTRRs to
>>> cover all available RAM, meaning the last few megs (or even gigs)
>>> of memory will be marked uncached.  Since Linux tends to allocate
>>> from high memory addresses first, this causes the machine to be
>>> unusably slow as soon as the kernel starts really using memory
>>> (i.e. right around init time).
>>
>> In theory -- while not recommended -- a BIOS could also
>> use a default fallback MTRR for cached and use explicit MTRRs to
>> map the non existing ranges uncached. Would it make sense to handle
>> this case?
>
> Probably.  I could just check the default memory type and bail out if
> it's cacheable.
>
>> Should also probably have some command line option
>> to disable the check in case something bad happens with it.
>
> Sure.
>
>> Another thing that might be sense to investigate in relationship
>> to this patch is large page mappings with MTRRs. iirc P4 and also K8
>> splits pages internally with MTRR boundaries and might have some
>> other bad side effects. Should we use this as hints to use 4K pages
>> for the boundary areas?
>
> Or I could trim to the nearest large page boundary...  We'd lose a
> little more memory but it would keep things simple.
>
> Jesse
>

How much more memory are we going to lose?  Is mem= a better option if its 
going to keep decreasing?
