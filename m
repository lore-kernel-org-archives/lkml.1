Return-Path: <linux-kernel-owner+w=401wt.eu-S1759082AbZAOCr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759082AbZAOCr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 21:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbZAOCrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 21:47:45 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:54763 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbZAOCro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 21:47:44 -0500
Date: Wed, 14 Jan 2009 19:47:40 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, chinang.ma@intel.com,
       linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com,
       arjan@linux.intel.com, suresh.b.siddha@intel.com,
       harita.chilukuri@intel.com, douglas.w.styner@intel.com,
       peter.xihong.wang@intel.com, hubert.nueckel@intel.com,
       chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org,
       Andrew Vasquez <andrew.vasquez@qlogic.com>,
       Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Subject: Re: Mainline kernel OLTP performance update
Message-ID: <20090115024740.GX29283@parisc-linux.org>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com> <CAC4B8726E86A142B27A9E9A2F2F12479D3E945F@rrsmsx505.amr.corp.intel.com> <20090114163557.11e097f2.akpm@linux-foundation.org> <20090115012147.GW29283@parisc-linux.org> <20090114180431.f4a96543.akpm@linux-foundation.org> <874p01fg3a.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874p01fg3a.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 03:39:05AM +0100, Andi Kleen wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
> >>    some of that back, but not as much as taking them out (even when
> >>    the sysctl'd variable is in a __read_mostly section).  We tried a
> >>    patch from Jens to speed up the search for a new partition, but it
> >>    had no effect.
> >
> > I find this surprising.
> 
> The test system has thousands of disks/LUNs which it writes to
> all the time, in addition to a workload which is a real cache pig. 
> So any increase in the per LUN overhead directly leads to a lot
> more cache misses in the kernel because it increases the working set
> there sigificantly.

This particular system has 450 spindles, but they're amalgamated into
30 logical volumes by the hardware or firmware.  Linux sees 30 LUNs.
Each one, though, has fifteen partitions on it, so that brings us back
up to 450 partitions.

This system, btw, is a scale model of the full system that would be used
to get published results.  If I remember correctly, a 1% performance
regression on this system is likely to translate to a 2% regression on
the full-scale system.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
