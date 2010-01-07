Return-Path: <linux-kernel-owner+w=401wt.eu-S932514Ab0AGIGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514Ab0AGIGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 03:06:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756230Ab0AGIGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 03:06:04 -0500
Received: from RELAY.ANDREW.CMU.EDU ([128.2.10.212]:37158 "EHLO
	relay.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224Ab0AGIGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 03:06:03 -0500
Date: Thu, 7 Jan 2010 03:04:38 -0500
From: Ben Blum <bblum@andrew.cmu.edu>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       menage@google.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/4] cgroups: support for module-loadable subsystems
Message-ID: <20100107080438.GB16656@andrew.cmu.edu>
References: <20091231051050.GA714@andrew.cmu.edu> <20100106160414.bd555474.akpm@linux-foundation.org> <20100107012606.GA25577@andrew.cmu.edu> <20100107120732.97d502bd.kamezawa.hiroyu@jp.fujitsu.com> <4B45824B.9030108@cn.fujitsu.com> <20100107161627.34b31e0c.kamezawa.hiroyu@jp.fujitsu.com> <20100107074812.GA16656@andrew.cmu.edu> <20100107165117.dca1dc52.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100107165117.dca1dc52.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 04:51:17PM +0900, KAMEZAWA Hiroyuki wrote:
> On Thu, 7 Jan 2010 02:48:12 -0500
> Ben Blum <bblum@andrew.cmu.edu> wrote:
> 
> > >  2. Making this to be reasonable value.
> > > #define CGROUP_SUBSYS_COUNT (BITS_PER_BYTE*sizeof(unsigned long))
> > >    I can't find why.
> > 
> > "We limit to this many since cgroupfs_root has subsys_bits to keep track
> > of all of them." should it be less, perhaps?
> 
> It's ok if it's clear that
> "this decistion is done by implementation choice, not by cgroup's nature"

mhm, well, it is the upper limit due to nature, but why it and not a
smaller number is by choice.

> 
> > the memory footprint is not
> > great, it is true, but implementing dynamically sized subsystem tracking
> > data structures requires much cleverer code in many places.
> > 
> yes. I don't request that.

it might be possible to have a config option as CGROUP_EXTRA_SUBSYSTEMS
(with max being 64 or 32) which would add slots for subsystems outside
of the kernel tree, to avoid using up a lot of blank slots in typical
use cases. not entirely sure how to implement it in the scope of the
configuration world, just speculation.

> > >  3. show whehter a subsys is a loadable module or not via /proc/cgroups
> > 
> > with just "y" or "n"? possible, and probably easy. do note that since
> > they are sorted by subsys_id, all the ones above a certain line will be
> > "n" and all below will be "y".
> > 
> yes. 
> 
> #subsys_name    hierarchy       num_cgroups     enabled  module
> cpuset  0       1       1	0
> 
> and 0/1 to show y/n ? (but this cause interface incompatibility...)

well, format should be agreed upon. 1/0 would be consistent with the
rest of the output.

> 
> 
> Thanks,
> -Kame
>    
> 
> 
