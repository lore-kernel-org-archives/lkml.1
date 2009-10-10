Return-Path: <linux-kernel-owner+w=401wt.eu-S1751181AbZJJEPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751181AbZJJEPW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 00:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbZJJEPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 00:15:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41730 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbZJJEPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 00:15:21 -0400
Date: Sat, 10 Oct 2009 06:14:42 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: Duplication of vdso and vsyscall code?
Message-ID: <20091010041442.GF1656@one.firstfloor.org>
References: <4ACFA80E.7050701@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ACFA80E.7050701@goop.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 02:15:58PM -0700, Jeremy Fitzhardinge wrote:
> arch/x86/kernel/vsyscall_64.c implements vgettimeofday and vgetcpu. 
> (And vtime)
> 
> arch/x86/vdso/vclock_gettime.c implements __vdso_gettimeofday (and
> __vdso_clock_gettime), and vgetcpu.c has __vdso_getcpu.
> 
> These appear to be functionally identical duplicate definitions.   I
> don't understand the history here to know how we came to get two sets of
> these functions, but surely we can share the same code for both of these?

One is at a fixed position in the user address space, and the other at a
randomized position. The fixed one came first. Fixed doesn't know
where randomized is. Randomized is also compiled and linked completely
differently. In theory the randomized one could call the fixed one, but
originally there were some thoughts about turning off fixed for some
applications that don't need it and also the path was considered very
performance critical, so unneeded jumps were avoided.
In theory you could probably #include the code from a common file, but it 
wouldn't buy you too much. I think there were originally some 
differences in the vgettimeofday() implementations too, although
that might have changed with all the timer reorganizations.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
