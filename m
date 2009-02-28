Return-Path: <linux-kernel-owner+w=401wt.eu-S1752611AbZB1Gwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbZB1Gwh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 01:52:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbZB1Gw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 01:52:28 -0500
Received: from gw.goop.org ([64.81.55.164]:34030 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbZB1Gw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 01:52:27 -0500
Message-ID: <49A8DF28.4050301@goop.org>
Date: Fri, 27 Feb 2009 22:52:24 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] xen: core dom0 support
References: <1235786365-17744-1-git-send-email-jeremy@goop.org> <20090227212812.26d02f34.akpm@linux-foundation.org>
In-Reply-To: <20090227212812.26d02f34.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 27 Feb 2009 17:59:06 -0800 Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> This series implements the core parts of Xen dom0 support; that is, just
>> enough to get the kernel started when booted by Xen as a dom0 kernel.
>>     
>
> And what other patches can we expect to see to complete the xen dom0
> support?
>   

There's a bit of a gradient.  There's probably another 2-3 similarly 
sized series to get everything so that you can boot dom0 out of the box 
(core, apic, swiotlb/agp/drm, backend drivers, tools).  And then a 
scattering of smaller things which may or may not be upstreamable.  The 
vast majority of it is Xen-specific code, rather than changes to core 
kernel.   I'm in no particular rush to get it all into the kernel, but I 
would like to get the core parts in for .30 so that its basically 
useful, and the delta to feature-complete isn't very large (a big reason 
is to keep the out-of-tree patch size down for distros).

> I hate to be the one to say it, but we should sit down and work out
> whether it is justifiable to merge any of this into Linux.  I think
> it's still the case that the Xen technology is the "old" way and that
> the world is moving off in the "new" direction, KVM?
>   

I don't think that's a particularly useful way to look at it.  They're 
different approaches to the problem, and have different tradeoffs.  

The more important question is: are there real users for this stuff?   
Does not merging it cause more net disadvantage than merging it?  
Despite all the noise made about kvm in kernel circles, Xen has a large 
and growing installed base.  At the moment its all running on massive 
out-of-tree patches, which doesn't make anyone happy.  It's best that it 
be in the mainline kernel.  You know, like we argue for everything else.

> In three years time, will we regret having merged this?
>   

Its a pretty minor amount of extra stuff on top of what's been added 
over the last 3 years, so I don't think it's going to tip the scales on 
its own.  I wouldn't be comfortable in trying to merge something that's 
very intrusive.

    J
