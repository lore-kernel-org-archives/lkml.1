Return-Path: <linux-kernel-owner+w=401wt.eu-S1759803AbYBST17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759803AbYBST17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:27:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754666AbYBST1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:27:50 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:21115 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbYBST1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:27:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Hj3aYnhKJlBQRid1PYipHUrgdrcu6t0tskV86UvaEchGcEJ6xomX3MNuCTXzWWcAm5VlfOLZQZ7OVPdS6zHwpT0ROYWPBJ/qq2Aij4g1ho6OQ8hPFlQNydPyXo59PJlJPn9Ic6cZztIMh4lGgmsmdFNtyfF8zZAD7RBFhVktKnA=
Message-ID: <64bb37e0802191127k2a202f4fm4bed2ea61c0fd7a8@mail.gmail.com>
Date: Tue, 19 Feb 2008 20:27:47 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.25-rc2
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <alpine.LFD.1.00.0802190806330.7833@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org>
	 <64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com>
	 <20080219061107.GA23229@elte.hu>
	 <64bb37e0802182254l49b10cbblc23f8a83d189ff8e@mail.gmail.com>
	 <84144f020802182321x452888bai639c71ea2a5067da@mail.gmail.com>
	 <20080219140230.GA32236@Krystal>
	 <84144f020802190621s509dbe7gc8e5609d94aca9b4@mail.gmail.com>
	 <84144f020802190638i4a364d19o8986a457e76ec187@mail.gmail.com>
	 <alpine.LFD.1.00.0802190806330.7833@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 19, 2008 5:20 PM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> So:
>  - it might be something else entirely
>  - it might still be the local cmpxchg, just Torsten didn't happen to
>    notice it until later.

My new hackbench-testcase also killed 2.6.24-rc2-mm1, so I really
noticed to late.

>  - it might still be the local cmpxchg, but something else changed its
>    patterns to actually make it start triggering.
>
> and in general I don't think we should revert it unless we have stronger
> indications that it really is the problem (eg somebody finds the actual
> bug, or a reporter can confirm that it goes away when the local cmpxchg
> optimization is disabled).

I tried the following three patches:

switching the barrier() for a smp_mb() in 2.6.25-rc2-mm1:
-> crashed

reverting the FASTPATH-patch in 2.6.25-rc2:
-> worked

only removed FAST_CMPXCHG_LOCAL from arch/x86/Kconfig
-> worked

So all of these tests seem to confirm, that the bug is in the new SLUB fastpath.

Torsten
