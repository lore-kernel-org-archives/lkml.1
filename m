Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbYDTO4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbYDTO4d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 10:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754371AbYDTO4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 10:56:25 -0400
Received: from sandeen.net ([209.173.210.139]:16191 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754609AbYDTO4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 10:56:24 -0400
Message-ID: <480B5997.30206@sandeen.net>
Date: Sun, 20 Apr 2008 09:56:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Shawn Bohrer <shawn.bohrer@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
References: <20080420080901.GF1595@cs181133002.pp.htv.fi> <20080420090623.7b173ef1@the-village.bc.nu> <20080420085104.GG1595@cs181133002.pp.htv.fi> <20080420103611.2c0d3519@the-village.bc.nu> <20080420104444.GI1595@cs181133002.pp.htv.fi> <20080420120250.4f496861@the-village.bc.nu> <20080420115455.GJ1595@cs181133002.pp.htv.fi> <20080420123731.7282bb16@the-village.bc.nu> <20080420121803.GK1595@cs181133002.pp.htv.fi> <480B4DB4.8070107@sandeen.net> <20080420142131.GD1899@cs181133002.pp.htv.fi>
In-Reply-To: <20080420142131.GD1899@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sun, Apr 20, 2008 at 09:05:40AM -0500, Eric Sandeen wrote:
>> Adrian Bunk wrote:
>>
>>> But the more users will get 4k stacks the more testing we have, and the 
>>> better both existing and new bugs get shaken out.
>>>
>>> And if there were only 4k stacks in the vanilla kernel, and therefore 
>>> all people on i386 testing -rc kernels would get it, that would give a 
>>> better chance of finding stack regressions before they get into a 
>>> stable kernel.
>> Heck, maybe you should make it 2k by default in all -rc kernels; that
>> way when people run -final with the 4k it'll be 100% bulletproof, right?
>>  'cause all those piggy drivers that blow a 2k stack will finally have
>> to get fixed?
> 
> I'm arguing for aiming at having all 32bit architectures with 4k page 
> size using the same stack size. Not for having -rc kernels differ from 
> release kernels.

Oh, I know.  I'm just saying that 4k seems chosen out of convenience for
memory management, without any real correlation to what you might
actually need to run a thread.  They do happen to be roughly equivalent
for many cases, but not all.  Setting a default which is not safe for
several common use cases does not seem wise...

I guess what I'm saying is, I don't agree that any callchain which needs
more than 4k of stack indicates brokenness that must be fixed, as
various posts in this thread seem to suggest.

Sure, 1k char buffers on the stack and massive structs and unlimited
recursion we can agree on as things to fix, but complex/deep/stacked
callchains which don't fit in 4k are much more of a grey area.

-Eric
