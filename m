Return-Path: <linux-kernel-owner+w=401wt.eu-S1753148AbXDEQVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbXDEQVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 12:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbXDEQVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 12:21:06 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:46765 "EHLO
	outbound4-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753148AbXDEQVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 12:21:04 -0400
X-BigFish: VP
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Thu, 5 Apr 2007 18:20:49 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Andi Kleen" <ak@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: limit mwait_idle to Intel CPUs
Message-ID: <20070405162049.GB14326@alberich.amd.com>
References: <20070405140045.GN6356@alberich.amd.com>
 <200704051624.45747.ak@suse.de>
 <20070405144442.GP6356@alberich.amd.com>
 <200704051737.17157.ak@suse.de>
MIME-Version: 1.0
In-Reply-To: <200704051737.17157.ak@suse.de>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 05 Apr 2007 16:20:44.0277 (UTC)
 FILETIME=[5C709A50:01C7779E]
X-WSS-ID: 6A0BFE552EW3270763-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2007 at 05:37:17PM +0200, Andi Kleen wrote:
> 
> > > > This patch will enable default_idle for non-Intel
> > > > CPUs even if mwait is supported.
> > > 
> > > It would be better to clear MONITOR/MWAIT in the AMD specific
> > > CPU initialize code than add workarounds everywhere else.
> > 
> > Why is that?
> > MONITOR/MWAIT is usable.
> 
> If it doesn't save power it's not usable imho.

But you can also think of monitor/mwait as a power saving means
for fast synchronization.

> > And I think this should 
> > be indicated by cpuinfo.
> > It's just inappropriate to use it in pm_idle.
> 
> There are no other users anyways and user space can't use it.
> Ok in theory you could add a X86_FEATURE_MWAIT_DOESNT_SAVE_POWER
> and check that, but just clearing it seems simpler and equivalent.

It is not equivalent. Usually users check /proc/cpuinfo for their
CPU features. Deleting that flag is kind of obfuscation.

I guess some time ago people did not care about their "svm" or "vmx"
flags. Nowadays (e.g. with kvm) some people are quite happy
if one of those strings occurs in /proc/cpuinfo (and they are quite
disappointed if this feature was disabled by BIOS).

Why not state it positively for CPUs that are able to even enter
C1 with MWAIT, e.g. X86_FEATURE_MWAIT_ENTERS_CSTATE?

If you dislike this wording than I still prefer to have the MWAIT
flag visible and but introducing an MWAIT_DOESNT_ENTER_CSTATE thing.

> What would perhaps make sense is to add a idle=mwait command
> line option for this though. So that the benchmarkers who currently
> use idle=poll could migrate to idle=mwait. That option would need
> to check the real cpuid bit of course again, but that should be
> easy enough.

That sounds good. Except that I prefer to check for
X86_FEATURE_MWAIT.



Regards,

Andreas

-- 
AMD Saxony, Dresden, Germany
Operating System Research Center
email: andreas.herrmann3@amd.com
phone: +49-351-277-4919



