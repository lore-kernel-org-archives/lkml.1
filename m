Return-Path: <linux-kernel-owner+w=401wt.eu-S936764AbXGSBWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936764AbXGSBWB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 21:22:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763455AbXGSBVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 21:21:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46859 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762640AbXGSBVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 21:21:49 -0400
Message-ID: <469EBC63.9020803@zytor.com>
Date: Wed, 18 Jul 2007 18:20:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Avi Kivity <avi@qumranet.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       caglar@pardus.org.tr
Subject: Re: [PATCH] i386: Decouple PAE from CONFIG_CMPXCHG64
References: <11847764879-git-send-email-avi@qumranet.com> <20070718181829.GA3848@one.firstfloor.org>
In-Reply-To: <20070718181829.GA3848@one.firstfloor.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>>
>> No processors that support KVM exist that also do not support CMPXCHG64,
>> so no additional check is necessary.  This setup allows for a single kernel
>> that will boot on i486 and also support KVM if available.
> 
> The CONFIG should only control the early CPUID checks, which are needed for PAE
> kernels.
> 
> But for something late like KVM the correct fix is really to drop
> the ifdefs around the macro and check boot_cpu_has() yourself.
> 

He's checking for the appropriate functionality at runtime.  What this
does is makes it impossible to select KVM when you have already selected
a CPU that doesn't support CX8.

One can, of course, question the utility, since the CPU set that
supports KVM all support CX8, but not vice versa...

	-hpa
