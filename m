Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899AbYFYJvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbYFYJvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 05:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754455AbYFYJvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 05:51:41 -0400
Received: from s36.avahost.net ([74.53.95.194]:44358 "EHLO s36.avahost.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754309AbYFYJvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 05:51:39 -0400
Message-ID: <486214F3.4070505@katalix.com>
Date: Wed, 25 Jun 2008 10:50:43 +0100
From: James Chapman <jchapman@katalix.com>
Organization: Katalix Systems Ltd
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Denys Vlasenko <vda.linux@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>, David Woodhouse <dwmw2@infradead.org>,
       Tim Bird <tim.bird@am.sony.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] Embedded Maintainer(s), linux-embedded@vger list
References: <1209577322.25560.402.camel@pmac.infradead.org> <1209636171.25560.508.camel@pmac.infradead.org> <20080501104158.GM20451@one.firstfloor.org> <200806231928.09458.vda.linux@googlemail.com> <20080623174537.GB4756@cs181140183.pp.htv.fi>
In-Reply-To: <20080623174537.GB4756@cs181140183.pp.htv.fi>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - s36.avahost.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - katalix.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Mon, Jun 23, 2008 at 07:28:09PM +0200, Denys Vlasenko wrote:
>> On Thursday 01 May 2008 12:41, Andi Kleen wrote:
>>>> To a large extent, I agree. I certainly don't want to focus solely on
>>>> code size; there's a lot more to embedded Linux than that. But it _is_
>>> Not only code size, far more important is dynamic memory consumption.
>>> [admittedly we right now lack a good instrumentation framework for this]
>>>
>>>> There are some cases where we really _do_ want to have CONFIG options,
>>>> but I agree that we should keep them to a minimum. And when we _do_ have
>>>> CONFIG options, they don't have to litter the actual code with ifdefs.
>>> The problem I see is more that really nobody can even compile not 
>>> alone test all these combinations anymore. Hidding the problem in inlines
>>> does not solve that. And no randconfig is not the solution either.
>> Because we allowed kernel to be developed without the requirement that
>> random config should be buildable for release kernels.
>>
>> Had it been a requirement, keeping it in shape wouldn't be
>> too difficult.
>>
>> Sure enough, _now_ fixing kernel to pass such a test on i386
>> would take several weeks of work at least. But it is doable.
>> ...
> 
> On i386 it might even already work today.
> 
> But guess how much time it costs to get at least all defconfigs 
> compiling on the other 22 architectures.
> 
> Even getting allmodconfig/allyesconfig compiling isn't trivial for all 
> architectures, and random configurations are _far_ from compiling.
 >
 > And we are not talking about something to be done once, as soon as you
 > leave x86 there are tons of regular breakages.

Could automated builds and build error reporting be used to help resolve 
these problems?

The good people at Simtec have an automated build report available as an 
e-mail digest. I use it to watch for architecture build breakages in 
subsystems or drivers that I use or touch. It covers defconfigs of ARM 
and MIPS architectures and reports compile errors/warnings, module size, 
kernel size etc. If this approach were extended/distributed to cover 
more architectures and random config builds, developers could with 
little effort spot problems and fix them. Hell, it might also encourage 
new developers to get involved and contribute.

Here's a link to a recent report for ARM, fyi:-

http://lists.simtec.co.uk/pipermail/kautobuild/2008-June/001299.html

> Plus the fact that you often get into situations where more options
> mean complex and fragile stuff. Read the Kconfig files under 
> drivers/media/ and check in git all commits to them since 2.6.25 alone, 
> and you'll understand why "add an option for every bit" can result in
> very high ongoing maintainance work required.
> 
> Not everything that is technically possible is also maintainable, and 
> maintainability is a very important point in a project with several 
> million lines changing each year.
> 
>> vda
> 
> cu
> Adrian

-- 
James Chapman
Katalix Systems Ltd
http://www.katalix.com
Catalysts for your Embedded Linux software development

