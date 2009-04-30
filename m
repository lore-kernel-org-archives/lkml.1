Return-Path: <linux-kernel-owner+w=401wt.eu-S1763344AbZD3Nrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763344AbZD3Nrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 09:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763323AbZD3NrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 09:47:25 -0400
Received: from ultra7.eskimo.com ([204.122.16.70]:4405 "EHLO ultra7.eskimo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763330AbZD3NrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 09:47:24 -0400
Date: Thu, 30 Apr 2009 06:46:33 -0700
From: Elladan <elladan@eskimo.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Theodore Tso <tytso@mit.edu>, Wu Fengguang <fengguang.wu@intel.com>,
       Peter Zijlstra <peterz@infradead.org>, Elladan <elladan@eskimo.com>,
       linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>
Subject: Re: Swappiness vs. mmap() and interactive response
Message-ID: <20090430134632.GA31807@eskimo.com>
References: <20090428090916.GC17038@localhost> <20090428120818.GH22104@mit.edu> <20090429130430.4B11.A69D9226@jp.fujitsu.com> <2f11576a0904300459t61ae9619tcf8defacfc94f79@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2f11576a0904300459t61ae9619tcf8defacfc94f79@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 08:59:59PM +0900, KOSAKI Motohiro wrote:
> > test environment: no lvm, copy ext3 to ext3 (not mv), no change swappiness,
> >                  CFQ is used, userland is Fedora10, mmotm(2.6.30-rc1 + mm patch),
> >                  CPU opteronx4, mem 4G
> >
> > mouse move lag:               not happend
> > window move lag:              not happend
> > Mapped page decrease rapidly: not happend (I guess, these page stay in
> >                                          active list on my system)
> > page fault large latency:     happend (latencytop display >1200ms)
> >
> >
> > Then, I don't doubt vm replacement logic now.
> > but I need more investigate.
> > I plan to try following thing today and tommorow.
> >
> >  - XFS
> >  - LVM
> >  - another io scheduler (thanks Ted, good view point)
> >  - Rik's new patch
> 
> hm, AS io-scheduler don't make such large latency on my environment.
> Elladan, Can you try to AS scheduler? (adding boot option "elevator=as")

I switched at runtime with /sys/block/sd[ab]/queue/scheduler, using Rik's
second patch for page replacement.  It was hard to tell if this made much
difference in latency, as reported by latencytop.  Both schedulers sometimes
show outliers up to 1400msec or so, and the average latency looks like it may
be similar.

Thanks,
Elladan

