Return-Path: <linux-kernel-owner+w=401wt.eu-S1754041AbZBEVGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbZBEVGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 16:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbZBEVGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 16:06:13 -0500
Received: from gate.crashing.org ([63.228.1.57]:46437 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbZBEVGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 16:06:11 -0500
Subject: Re: [Bug #12608] 2.6.29-rc powerpc G5 Xorg legacy_mem regression
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <Pine.LNX.4.64.0902051713550.1445@blonde.anvils>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
	 <pWZw1SZjMCH.A.sIE.wuYiJB@chimera> <1233791329.4612.23.camel@pasglop>
	 <Pine.LNX.4.64.0902051713550.1445@blonde.anvils>
Content-Type: text/plain
Date: Fri, 06 Feb 2009 08:05:44 +1100
Message-Id: <1233867944.4612.104.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Is it a really a bug in X, or a misunderstanding between X and
> the kernel as to what existence of the legacy_mem file implies?
> 
> I may have got this quite wrong, but to me it appears that X assumes
> that existence of the legacy_mem file implies that it will be useful;
> whereas the kernel thinks it can make the legacy_mem file available,
> even if it cannot be used for mmapping mem - which is its sole purpose?
> 
> What if pci_create_legacy_files() were to call some new verification
> routine, and only create the legacy_mem file if it would be usable?
> (But perhaps that cannot be known at the time it needs to be created.)

Well, first X should certainly not -fail- to launch if it fails to map
legacy memory, which is generally not useful anyway. That's where the
bug is. Jesse, did you have a chance to fix that yet or should I give it
a go ?

The second problem is that if I just don't expose the legacy_mem file,
then X has no way to know whether the kernel doesn't support the
interface or whether the HW doesn't support legacy memory access. So X
will fallback to whacking /dev/mem which is even more bogus. At least
that's what I remember from last I looked at that part of X code.

It should be a trivial fix on X side tho.

Cheers,
Ben.


