Return-Path: <linux-kernel-owner+w=401wt.eu-S1753327AbXDERF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbXDERF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 13:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbXDERF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 13:05:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:40513 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327AbXDERF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 13:05:57 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Andreas Herrmann" <andreas.herrmann3@amd.com>
Subject: Re: [PATCH] x86: limit mwait_idle to Intel CPUs
Date: Thu, 5 Apr 2007 19:05:45 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <20070405140045.GN6356@alberich.amd.com> <200704051737.17157.ak@suse.de> <20070405162049.GB14326@alberich.amd.com>
In-Reply-To: <20070405162049.GB14326@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704051905.45660.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 April 2007 18:20:49 Andreas Herrmann wrote:
> On Thu, Apr 05, 2007 at 05:37:17PM +0200, Andi Kleen wrote:
> > 
> > > > > This patch will enable default_idle for non-Intel
> > > > > CPUs even if mwait is supported.
> > > > 
> > > > It would be better to clear MONITOR/MWAIT in the AMD specific
> > > > CPU initialize code than add workarounds everywhere else.
> > > 
> > > Why is that?
> > > MONITOR/MWAIT is usable.
> > 
> > If it doesn't save power it's not usable imho.
> 
> But you can also think of monitor/mwait as a power saving means
> for fast synchronization.

Just the kernel doesn't use it for that (except in idle) and user
space can't use it anyways because it's ring 0 only.

> It is not equivalent. Usually users check /proc/cpuinfo for their
> CPU features. Deleting that flag is kind of obfuscation.

On the other hand wouldn't they expect mwait to be used if it's displayed
there? I don't see it as an obfuscation to make this clear.

Also it's not that someone's marketing strategy will depend on MWAIT
being displayed in cpuinfo. If it was something hyped like SSE* 
or 3dnow perhaps, but that's not the case.

> I guess some time ago people did not care about their "svm" or "vmx"
> flags. Nowadays (e.g. with kvm) some people are quite happy
> if one of those strings occurs in /proc/cpuinfo (and they are quite
> disappointed if this feature was disabled by BIOS).

Well older kernels don't know it, so actually a lot of people
learned to use another program to check anyways.

> Why not state it positively for CPUs that are able to even enter
> C1 with MWAIT, e.g. X86_FEATURE_MWAIT_ENTERS_CSTATE?

It seems a bit counterintuitive to add special code for CPUs
that do something right to avoid adding code to CPUs that do otherwise.

> > What would perhaps make sense is to add a idle=mwait command
> > line option for this though. So that the benchmarkers who currently
> > use idle=poll could migrate to idle=mwait. That option would need
> > to check the real cpuid bit of course again, but that should be
> > easy enough.
> 
> That sounds good. Except that I prefer to check for
> X86_FEATURE_MWAIT.

Ok, perhaps the second cpuid would be a bit ugly. Then do two
flags if you prefer that.

-Andi

