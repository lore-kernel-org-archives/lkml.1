Return-Path: <linux-kernel-owner+w=401wt.eu-S1751876AbZHBDxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbZHBDxV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 23:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbZHBDxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 23:53:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42257 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbZHBDxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 23:53:20 -0400
Message-ID: <4A750D66.6050203@zytor.com>
Date: Sat, 01 Aug 2009 20:52:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>
Subject: Re: [GIT PULL] Additional x86 fixes for 2.6.31-rc5
References: <200907311813.n6VIDe9S023442@voreg.hos.anvin.org>	<alpine.LFD.2.01.0907311218080.3161@localhost.localdomain>	<20090731195705.GA12270@elte.hu>	<alpine.LFD.2.01.0908011214330.3304@localhost.localdomain>	<4A7499BA.2000405@zytor.com>	<alpine.LFD.2.01.0908011501470.3352@localhost.localdomain> <19060.59896.983880.446901@cargo.ozlabs.ibm.com>
In-Reply-To: <19060.59896.983880.446901@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2009 06:20 PM, Paul Mackerras wrote:
> When I tried using __thread for per-cpu variables on ppc64, I found
> that gcc would sometimes precompute and cache the address of a per-cpu
> variable even though it could always access the variable using an
> offset from r13.  The cached address was wrong if the task got moved
> to a different cpu, of course, but there was no way to tell gcc that.
> Compiler barriers don't help because they say that the contents of
> variables might have changed, but not their addresses.
> 
> So on x86 the concern would be that gcc might do lea %gs:foo,%rbx and
> then use (%rbx) to refer to foo later on.  It would be possible to use
> __thread for per-task variables rather than having to put all per-task
> things in the task_struct, but __thread doesn't work for per-cpu
> variables in my experience.

You can't actually do "lea %gs:foo,%rbx" (lea doesn't include the
segment offset, unfortunately; I asked AMD to change that on 64 bits
but, not too surprisingly, they weren't able to make that change.)
Getting the address is expensive, but it's obviously possible -- which
may have similar bad results.  It would be worth experimenting with a
little bit, though.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

