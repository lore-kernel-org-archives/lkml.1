Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbXKFTux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbXKFTux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 14:50:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756053AbXKFTup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 14:50:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47928 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012AbXKFTuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 14:50:44 -0500
Message-ID: <4730C575.2020007@zytor.com>
Date: Tue, 06 Nov 2007 11:50:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Andi Kleen <andi@firstfloor.org>, Ray Lee <ray-lk@madrabbit.org>,
       =?ISO-8859-1?Q?Bo_Brant=E9n?= <bosse@acc.umu.se>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: x86_64 ten times slower than i386
References: <Pine.A41.4.64.0711031329490.397338@stalin.acc.umu.se> <20071103162640.GS17536@waste.org> <Pine.A41.4.64.0711032334170.770224@stalin.acc.umu.se> <Pine.A41.4.64.0711051110530.803034@stalin.acc.umu.se> <Pine.A41.4.64.0711051657440.291004@stalin.acc.umu.se> <2c0942db0711050832t5207ea8bib1f75e59e071ade2@mail.gmail.com> <20071106002647.GA27182@one.firstfloor.org> <472FC130.40605@zytor.com> <20071106194009.GC1045@1wt.eu>
In-Reply-To: <20071106194009.GC1045@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> On Mon, Nov 05, 2007 at 05:19:44PM -0800, H. Peter Anvin wrote:
>> Andi Kleen wrote:
>>>> Jesse Barnes (cc:d) wrote a patch to address this, I think (x86: trim
>>>> memory not covered by WB MTRRs), but as far as I can tell it hasn't
>>>> been merged yet. System is Intel, 4gb of RAM.
>>> It wasn't merged because it broke booting on some systems.
>>> Besides the memory would be still lost -- all it did was to automate
>>> the "mem=XXXX" line.
>> There really are only two ways to deal with this -- drop the memory 
>> (which should be automated, and a warning printed) or adjust the MTRRs. 
>>  The problem is that at some point we run out of MTRRs, partially 
>> because they're masks instead of base/limit.
> 
> Just out of curiosity, what would be the problem if the MTRRs covered more
> than the memory size ? For instance, instead of having 512 MB at 4G, why
> not have 1G at 4G ?

That's fine, *as long as* you don't have any I/O devices there, 
including things like UMA graphics devices or memory areas used by SMM. 
  In theory, those should be marked reserved in e820.  In practice...

That's really the fundamental problem with the Intel MTRR design.  It 
works really well for banks of memory and really poorly as soon as 
something wants to "steal" memory or address space.

	-hpa
