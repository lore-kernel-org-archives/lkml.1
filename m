Return-Path: <linux-kernel-owner+w=401wt.eu-S1767097AbXDEPh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767097AbXDEPh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 11:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767098AbXDEPh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 11:37:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38612 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767097AbXDEPh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 11:37:27 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Andreas Herrmann" <andreas.herrmann3@amd.com>
Subject: Re: [PATCH] x86: limit mwait_idle to Intel CPUs
Date: Thu, 5 Apr 2007 17:37:17 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <20070405140045.GN6356@alberich.amd.com> <200704051624.45747.ak@suse.de> <20070405144442.GP6356@alberich.amd.com>
In-Reply-To: <20070405144442.GP6356@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704051737.17157.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > > This patch will enable default_idle for non-Intel
> > > CPUs even if mwait is supported.
> > 
> > It would be better to clear MONITOR/MWAIT in the AMD specific
> > CPU initialize code than add workarounds everywhere else.
> 
> Why is that?
> MONITOR/MWAIT is usable.

If it doesn't save power it's not usable imho.

> And I think this should 
> be indicated by cpuinfo.
> It's just inappropriate to use it in pm_idle.

There are no other users anyways and user space can't use it.
Ok in theory you could add a X86_FEATURE_MWAIT_DOESNT_SAVE_POWER
and check that, but just clearing it seems simpler and equivalent.

What would perhaps make sense is to add a idle=mwait command
line option for this though. So that the benchmarkers who currently
use idle=poll could migrate to idle=mwait. That option would need
to check the real cpuid bit of course again, but that should be
easy enough.

-Andi

