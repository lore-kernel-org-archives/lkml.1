Return-Path: <linux-kernel-owner+w=401wt.eu-S1031706AbXEANci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031706AbXEANci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 09:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031705AbXEANci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 09:32:38 -0400
Received: from rtr.ca ([64.26.128.89]:3269 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031704AbXEANcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 09:32:36 -0400
Message-ID: <46374171.1050009@rtr.ca>
Date: Tue, 01 May 2007 09:32:33 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Andi Kleen <ak@suse.de>, ebiederm@xmission.com, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [30/30] x86_64: Add missing !X86_PAE dependincy to the
 2G/2G split.
References: <20070501557.815359000@suse.de> <20070501035829.1C93D13CAF@wotan.suse.de> <20070501043735.GR31925@holomorphy.com>
In-Reply-To: <20070501043735.GR31925@holomorphy.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> On Tue, May 01, 2007 at 05:58:29AM +0200, Andi Kleen wrote:
>> From: ebiederm@xmission.com
>> When in PAE mode we require that the user kernel divide to be
>> on a 1G boundary.  The 2G/2G split does not have that property
>> so require !X86_PAE
>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>> ---
>>  arch/i386/Kconfig |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> What on earth?
> 
> config PAGE_OFFSET
>         hex
>         default 0xB0000000 if VMSPLIT_3G_OPT
>         default 0x78000000 if VMSPLIT_2G
>         default 0x40000000 if VMSPLIT_1G
>         default 0xC0000000
> 
> This appears to have been introduced by:
> commit 975b3d3d5b983eb60706d35f0d24cd19f6badabf
> Author: Mark Lord <lkml@rtr.ca>
> Date:   Wed Feb 1 03:06:11 2006 -0800
>     [PATCH] VMSPLIT config options
> 
> There's some sort of insanity going on here. Since when is 0x78000000
> a 2GB/2GB split? Mark, dare I ask what you were thinking? That should
> be VMSPLIT_2G_OPT for 2GB laptops analogously to VMSPLIT_3G_OPT, if
> nothing else, as it's certainly not 2GB/2GB.

You need to go search the archives and read the *extensive* thread
on this from when it was introduced.  Lots of high profile kernel
developers were in on this one.

The idea is really simple:  eliminate the need for HIGHMEM
on common machines.  

And yes, VMSPLIT_2G really means VMSPLIT_2G_OPT,
in the same way as the (added last) VMSPLIT_3G_OPT flag.

Cheers
