Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbYJURc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbYJURc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 13:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbYJURct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 13:32:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43249 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbYJURct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 13:32:49 -0400
Date: Tue, 21 Oct 2008 19:40:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alok Kataria <akataria@vmware.com>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
Subject: Re: [PATCH 0/3] Improve TSC as a clocksource under VMware
Message-ID: <20081021174008.GH12825@one.firstfloor.org>
References: <1224552902.2640.88.camel@alok-dev1> <874p36fflp.fsf@basil.nowhere.org> <1224607284.6161.22.camel@alok-dev1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224607284.6161.22.camel@alok-dev1>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > It would be far nicer if VMware just emulated the "constant_tsc" bit
> > in the AMD CPUID leaf, instead of adding all that gunk to Linux.
> > Right now it's only checked for AMD CPUs, but that could be changed.
> 
> I am not sure if we might want to skip the tsc_sync code for all the
> cpus which have this constant_tsc bit set, can we ?

It should be ok, although normally sanity checks should be kept.

> Since i have seen that we can have cases where tsc is marked unstable as
> its not found to be perfectly stable between cpus, we have to make sure
> that we avoid this check when on VMware. Even with slight difference in

Normally tsc sync should only fail when the error is large.
It cannot detect very small derivation by design. It's more like
a sanity check "does the TSC sync look half way sane"

If it fails on VMware perhaps the margins are not big enough or 
something else is fishy.

But still it could be skipped with constant_tsc. But again you
shouldn't really fail that check -- if you do fail are you
sure your clock is really synchronized enough that there
are no observable differences?

> TSC between cpus, we know that TSC is the best available clocksource as
> the hypervisor (VMware) makes sure that the drift is always marginal (if
> ever there is).

The drift has to be unobservable, otherwise you still risk
non monotonity.  Also when there is drift it has to be short
term only, otherwise it would accumulate over longer times.

-Andi

-- 
ak@linux.intel.com
