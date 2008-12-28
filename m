Return-Path: <linux-kernel-owner+w=401wt.eu-S1755006AbYL1AnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbYL1AnM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 19:43:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbYL1Am5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 19:42:57 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:43113 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521AbYL1Am4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 19:42:56 -0500
Date: Sun, 28 Dec 2008 00:43:26 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>
Subject: Re: linux-next: parsing mem=700M broken
In-Reply-To: <200812272342.54881.rusty@rustcorp.com.au>
Message-ID: <Pine.LNX.4.64.0812280033070.24494@blonde.anvils>
References: <Pine.LNX.4.64.0812230257440.27467@blonde.anvils>
 <200812241808.16195.rusty@rustcorp.com.au> <Pine.LNX.4.64.0812241437230.15556@blonde.anvils>
 <200812272342.54881.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Dec 2008, Rusty Russell wrote:
> > On Thursday 25 December 2008 01:14:35 Hugh Dickins wrote:
> > But (of course: it's a patch to arch/x86) doesn't help at all on
> > ppc64; and I presume other architectures also remain broken...
> 
> Confirmed ppc64.  But it's broken in a *different* way.
> 
> Whereas most archs called parse_early_param from setup_arch, powerpc
> does it before start_kernel.  So instead of moving parsing earlier,
> my patch actually moved it later for powerpc.
> 
> Too late, for mem=.
> 
> Rather than try to untangle the powerpc boot process (most archs would
> do most of this in setup_arch), I think I have to expose the parser
> again so they can call it:
> 
> commit 25bf48b74b9fb23b347d00656b604f9e55c72183
> Author: Rusty Russell <rusty@rustcorp.com.au>
> Date:   Sat Dec 27 23:40:37 2008 +1030
> 
>     Fix powerpc (tested on ppc64) command line handling.
>     Powerpc used to call parse_early_param() really early; the change made
>     it too late.  Put it back.

I'll make no pretence of reviewing any of this, but this has
indeed got mem= back working for me on a 2.6.28-rc9-mm1 - thanks!

I have to wonder if all this comes too late in the cycle for 2.6.29:
changing the early param handling of all the arches is difficult,
and apparently hasn't been much tested in the short time that it's
been out there in linux-next.  But of course, not for me to decide.

Hugh
