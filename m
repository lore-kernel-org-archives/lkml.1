Return-Path: <linux-kernel-owner+w=401wt.eu-S1756078AbXD0Qzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbXD0Qzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 12:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756085AbXD0Qzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 12:55:39 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3272 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078AbXD0QzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 12:55:23 -0400
Message-ID: <46322AFD.5000706@shadowen.org>
Date: Fri, 27 Apr 2007 17:55:25 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm2 -- PPC link failure
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org> <4630A662.8090502@shadowen.org> <4630ABF2.1040305@shadowen.org> <4630EBFA.9000207@shadowen.org> <Pine.LNX.4.64.0704261123080.3560@schroedinger.engr.sgi.com> <4630F203.7020005@shadowen.org> <Pine.LNX.4.64.0704261210430.7441@schroedinger.engr.sgi.com> <46310216.2070608@shadowen.org> <Pine.LNX.4.64.0704261320090.5678@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0704261320090.5678@schroedinger.engr.sgi.com>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 26 Apr 2007, Andy Whitcroft wrote:
> 
>>> Gcc 3.3 works just fine on other platforms like i386. This is more likely 
>>> a platform issue. If we disable it then only for <= gcc 3.3 on ppc. If 
>>> problems crop up with other platforms then we can expand on it.
>> I was thinking that it would be nasty to have a set of platform
>> specific, compiler specific ifdefs in here.  I was more thinking of just
>> making this a BUG for all platforms.  This does result in slightly later
>> detection but this is a constant mode only, so any bad use of kmalloc()
>> would be picked up on first boot in testing always.
>>
>> I think that would be sufficient and safe even against the worst
>> optimiser (none).  Plus much less horrible to look at?
> 
> The build time detection is quite important for NUMA since structures keep 
> growing. I'd like to keep that. In fact I would really like a build time 
> detection. If a too large kmalloc occurs then the compile should stop at 
> that point and the kernel should not link at all.
> 
> See my patch @ http://marc.info/?l=linux-kernel&m=117752927203466&w=2

Yeah I played with that for a bit last night to no good effect.
BUILD_BUG_ON simply becomes a noop if the optimiser doesn't really
really know that the thing its talking about is a real constant.

I assume that if it cannot be sure that it should constant fold the
number, it leaves it for runtime.  Then the optimiser sees that the
thing is void and therefore removable and removes it.  So no error.

Perhaps we need to enlist someone from gcc-land to tell us how to figure
out what its doing and massage it into working.

-apw
