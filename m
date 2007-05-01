Return-Path: <linux-kernel-owner+w=401wt.eu-S1423719AbXEAE5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423719AbXEAE5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 00:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423720AbXEAE5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 00:57:34 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:37875 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423719AbXEAE5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 00:57:33 -0400
Message-ID: <4636C8AF.6080404@cosmosbay.com>
Date: Tue, 01 May 2007 06:57:19 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: Andi Kleen <ak@suse.de>, Mark Lord <lkml@rtr.ca>, ebiederm@xmission.com,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [30/30] x86_64: Add missing !X86_PAE dependincy to the
 2G/2G split.
References: <20070501557.815359000@suse.de> <20070501035829.1C93D13CAF@wotan.suse.de> <20070501043735.GR31925@holomorphy.com>
In-Reply-To: <20070501043735.GR31925@holomorphy.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Tue, 01 May 2007 06:57:26 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III a écrit :
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

Please could you stop saying others are insane ?

They are like you and can fail sometime. Apparently when the patch came, 
nobody (including you) commented.

It's not that difficult to think about VMALLOC space (I might be wrong about 
this, but I feel this explains 78000000 vs 80000000)

> 
> These VMSPLIT config options vs. PAE are foul as they're now done in
> any event. If they were done properly, they'd properly set up the pmd
> within which the division point between user and kernelspace falls.
> 
> This patch, I suppose, stops people from shooting themselves in the
> foot, but (IMHO) the VMSPLIT patches shouldn't have been merged
> without handling the partial pmd case. 2MB/4MB resolution is enough
> granularity for any reasonable purpose, so split ptes aren't worth the
> effort, but this nonsense with PAE vs. VMSPLIT is just preposterous.
> If you're going to play the VMSPLIT game at all, handle split pmd's.
> 
> I'll see what else is pending in the i386 pagetable arena and clear
> this up if there aren't other objections (this is where Andi gets to
> complain that things are too complex already and preemptively NAK to
> save me the effort, if it's not seen to be desirable). Eric, your patch
> is a reasonable stop-gap measure for the original deficiency.


