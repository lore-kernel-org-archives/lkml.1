Return-Path: <linux-kernel-owner+w=401wt.eu-S1754995AbYCHHau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995AbYCHHau (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 02:30:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbYCHHam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 02:30:42 -0500
Received: from 1wt.eu ([62.212.114.60]:2316 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbYCHHal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 02:30:41 -0500
Date: Sat, 8 Mar 2008 08:30:01 +0100
From: Willy Tarreau <w@1wt.eu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Chris Snook <csnook@redhat.com>,
       Andrew Buehler <abuehler.kernel@gmail.com>,
       Frederik Deweerdt <deweerdt@free.fr>, belcampo <belcampo@zonnet.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: Hyperthreading performance oddities
Message-ID: <20080308073000.GH8953@1wt.eu>
References: <47BE9781.3030304@zonnet.nl> <20080222100630.GE5906@slug> <47D14526.2070103@gmail.com> <47D192BF.5090501@redhat.com> <87zltae3y7.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zltae3y7.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Fri, Mar 07, 2008 at 08:20:32PM +0100, Andi Kleen wrote:
> Chris Snook <csnook@redhat.com> writes:
> > 
> > Turning on hyperthreading effectively halves the amount of cache
> > available for each logical CPU when both are doing work, which can do
> > more harm than good.
> 
> When the two cores are in the same address space (as in being two
> threads of the same process) L1 cache will be shared on P4. I think
> for the other cases the cache management is also a little more
> sophisticated than a simple split, depending on which HT generation
> you're talking about (Intel had at least 4 generations out, each with
> improvements over the earlier ones)

Oh that's quite interesting to know.

> BTW your argument would be in theory true also for multi core with
> shared L2 or L3, but even there the CPUs tend to be more sophisticated.
> e.g. Core2 has a mechanism called "adaptive cache" which allows one
> Core to use significantly more of the L2 in some cases.
>
> >  Number-crunching applications that utilize the
> > cache effectively generally don't benefit from hyperthreading,
> > particularly floating-point-intensive ones.
> 
> That sounds like a far too broad over generalization to me.
> 
> -Andi (who personally always liked HT)

Well, in my experience, except for compiling, HT has always caused
massive slowdowns, especially on network-intensive applications.
Basically, network perf took a 20-30% hit, while compiling took
20-30% boost. But I must admit that I never tried HT on anything
more recent than a P4, maybe things have changed since.

regards,
willy

