Return-Path: <linux-kernel-owner+w=401wt.eu-S1757935AbXIYRwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935AbXIYRwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 13:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbXIYRwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 13:52:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441AbXIYRwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 13:52:17 -0400
Date: Tue, 25 Sep 2007 13:51:56 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, Greg.Chandler@wellsfargo.com,
       cpufreq@lists.linux.org.uk, linux-kernel@vger.kernel.org,
       dan.j.williams@intel.com, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 1/1] Kernel compile bug in 2.6.22.6/7 {maybe more}
	ARM/StrongARM
Message-ID: <20070925175156.GG2769@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Russell King <rmk+lkml@arm.linux.org.uk>,
	Greg.Chandler@wellsfargo.com, cpufreq@lists.linux.org.uk,
	linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
	Andi Kleen <ak@suse.de>
References: <1E7A4807A136DF45AD33DB341D93C3BD1F0C19@msgswbmnmsp46.wellsfargo.com> <20070925073132.GA29127@flint.arm.linux.org.uk> <20070925143651.GA2769@redhat.com> <20070925095229.d1aec1a5.akpm@linux-foundation.org> <20070925165834.GE2769@redhat.com> <20070925100839.8d2e7b40.akpm@linux-foundation.org> <20070925172255.GL8127@redhat.com> <20070925103142.c93719b3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070925103142.c93719b3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 10:31:42AM -0700, Andrew Morton wrote:
 > On Tue, 25 Sep 2007 13:22:55 -0400 Dave Jones <davej@redhat.com> wrote:
 > 
 > >  > 
 > >  > OK, here: ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm3/broken-out/fix-x86_64-mm-sched-clock-share.patch
 > >  > 
 > >  > So I guess what we want to do here is to revert that patch, test i386
 > >  > allnoconfig and then fix up anything which breaks.
 > > 
 > > Nothing breaks for me with make ARCH=i386 bzImage on my x86-64 box
 > > (which should be the same as a native build).
 > 
 > Was that with allnoconfig?

yeah.

 > > The functions that complain in that patch header don't seem to actually
 > > exist in mainline at all. (`init_sched_clock' and `call_r_s_f')
 > > Did this patch perhaps jump the gun, and these are -mm only ?
 > 
 > Could be that this patch fixed version 17 of sched-clock-share and we ended
 > up merging verion 56.  It was awful.

heh.

I think just reverting that change for .23 makes sense. It doesn't
seem that anything breaks by not having it there, and we know it
definitly breaks arm at least.

	Dave

-- 
http://www.codemonkey.org.uk
