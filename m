Return-Path: <linux-kernel-owner+w=401wt.eu-S1755610AbZEPIyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbZEPIyt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 04:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbZEPIyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 04:54:40 -0400
Received: from mga14.intel.com ([143.182.124.37]:10260 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbZEPIyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 04:54:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,204,1241420400"; 
   d="scan'208";a="143508285"
Date: Sat, 16 May 2009 16:54:16 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "riel@redhat.com" <riel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Subject: Re: [PATCH -mm] vmscan: protect a fraction of file backed mapped
	pages from reclaim
Message-ID: <20090516085416.GA10221@localhost>
References: <20090512120002.D616.A69D9226@jp.fujitsu.com> <alpine.DEB.1.10.0905121650090.14226@qirst.com> <20090513084306.5874.A69D9226@jp.fujitsu.com> <alpine.DEB.1.10.0905141612100.15881@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0905141612100.15881@qirst.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Fri, May 15, 2009 at 04:14:31AM +0800, Christoph Lameter wrote:
> On Wed, 13 May 2009, KOSAKI Motohiro wrote:
> 
> > > All these expiration modifications do not take into account that a desktop
> > > may sit idle for hours while some other things run in the background (like
> > > backups at night or updatedb and other maintenance things). This still
> > > means that the desktop will be usuable in the morning.
> >
> > Have you seen this phenomenom?
> > I always use linux desktop for development. but I haven't seen it.
> > perhaps I have no luck. I really want to know reproduce way.
> >
> > Please let me know reproduce way.
> 
> Run a backup (or rsync) over a few hundred GB.

Simple experiments show that rsync is use-once workload:

1) fresh run(full backup): the source file pages in the logo/ dir are cached and
   referenced *once*:

        rsync -a logo localhost:/tmp/

2) second run(incremental backup): only the updated files are read and
   read only once:

        rsync -a logo localhost:/tmp/

> > > The percentage of file backed pages protected is set via
> > > /proc/sys/vm/file_mapped_ratio. This defaults to 20%.
> >
> > Why do you think typical mapped ratio is less than 20% on desktop machine?
> 
> Observation of the typical mapped size of Firefox under KDE.

Since the explicit PROT_EXEC targeted mmap page protection plus Rik's
use-once patch works just OK for rsync - a typical backup scenario,
and it works without an extra sysctl tunable, I tend to continue
pushing the PROT_EXEC approach :-)

Thanks,
Fengguang

> > key point is access-once vs access-many.
> 
> Nothing against it if it works.
