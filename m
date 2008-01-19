Return-Path: <linux-kernel-owner+w=401wt.eu-S1763794AbYASD3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763794AbYASD3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 22:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759879AbYASD3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 22:29:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756454AbYASD3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 22:29:10 -0500
Date: Fri, 18 Jan 2008 22:28:49 -0500
From: Dave Jones <davej@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <Yinghai.Lu@Sun.COM>, venkatesh.pallipadi@intel.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] X86: fix typo PAT to X86_PAT
Message-ID: <20080119032849.GA16757@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ingo Molnar <mingo@elte.hu>, Yinghai Lu <Yinghai.Lu@Sun.COM>,
	venkatesh.pallipadi@intel.com, LKML <linux-kernel@vger.kernel.org>
References: <20080118123140.GI11044@elte.hu> <20080118182437.GA10167@redhat.com> <20080118210210.GB10717@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080118210210.GB10717@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 10:02:10PM +0100, Ingo Molnar wrote:
 > 
 > * Dave Jones <davej@redhat.com> wrote:
 > 
 > >  > you mean modifies MTRRs? Which code is that? (besides the 
 > >  > /proc/mtrr userspace API)
 > > 
 > > This exclusion is going to be a real pain in the ass for distro 
 > > kernels. It's impossible for example to build a kernel that will now 
 > > support the MTRR-alike registers on the AMD K6/early Cyrix etc and 
 > > also support PAT.
 > > 
 > > Additionally, given people tend to update their kernels a lot more 
 > > often than they update to a whole new version of X, it means until 
 > > userspace has caught up, we can't ship a kernel with PAT supported, or 
 > > else X gets a lot slower due to the missing mtrr support.
 > 
 > there's no exclusion enforced right now, and if a CPU is PAT-incapable 
 > (or if the kernel is booted nopat) then the MTRR bits should be usable. 
 > But if we boot with PAT enabled, and Xorg gets /proc/mtrr wrong, we'll 
 > see nasty crashes. If it gets them right, it should all still work just 
 > fine. Is this ok? Then, in a year or two, distros can disable write 
 > support to /proc/mtrr. Hm?

A crazy idea just occured to me..  We could make /proc/mtrr an interface
to set PAT on a range of memory.  This would make it transparently work
without any changes in X or anything else that sets them in userspace.

	Dave

-- 
http://www.codemonkey.org.uk
