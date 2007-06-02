Return-Path: <linux-kernel-owner+w=401wt.eu-S1758299AbXFBIoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299AbXFBIoQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 04:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbXFBIoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 04:44:03 -0400
Received: from lucidpixels.com ([75.144.35.66]:53746 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbXFBIoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 04:44:01 -0400
Date: Sat, 2 Jun 2007 04:43:59 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Intel's response Linux/MTRR/8GB Memory Support / Why doesn't
 the kernel realize the BIOS has problems and re-map appropriately?
In-Reply-To: <200706011815.53065.jbarnes@virtuousgeek.org>
Message-ID: <Pine.LNX.4.64.0706020443490.32599@p34.internal.lan>
References: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan>
 <200706011441.57149.jbarnes@virtuousgeek.org> <20070602010539.GA13512@linux-os.sc.intel.com>
 <200706011815.53065.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 1 Jun 2007, Jesse Barnes wrote:

> On Friday, June 1, 2007 6:05:39 Venki Pallipadi wrote:
>> On Fri, Jun 01, 2007 at 02:41:57PM -0700, Jesse Barnes wrote:
>>> On Friday, June 1, 2007 2:19:43 Andi Kleen wrote:
>>>> And normally the MTRRs win, don't they (if I remember the table
>>>> correctly) So if the MTRR says UC and PAT disagrees it might not
>>>> actually help
>>>
>>> I just checked, yes the MTRRs win for UC types.  But it sounds like the
>>> cases we're talking about are actually situations where there's no MTRR
>>> coverage, so the default type is used.  The manual doesn't specifically
>>> call out how memory using the default type interacts with PAT, but it may
>>> well be that it stays uncached if the default type is uncached.  Again
>>> that argues for fixing the MTRR mapping problem in some way.
>>
>> I feel, having a silent/transparent workaround is not a good idea. With
>> that chances are BIOS bug will go unnoticed (having an error message in
>> dmesg may not get noticed either). Probably we should just panic at boot
>> with a
>> detailed message about the e820 mtrr discrepancy (which can be logged as
>> a BUG to BIOS provider) and suggest a temporary workaround of "mem=___".
>
> That might be best, short of actually fixing the MTRRs...
>
> Jesse
>
>

Indeed, at least it will inform the user of -what- is going on.
