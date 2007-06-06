Return-Path: <linux-kernel-owner+w=401wt.eu-S934287AbXFFDf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934287AbXFFDf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 23:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbXFFDfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 23:35:16 -0400
Received: from 1wt.eu ([62.212.114.60]:2858 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbXFFDfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 23:35:15 -0400
Date: Wed, 6 Jun 2007 05:33:30 +0200
From: Willy Tarreau <w@1wt.eu>
To: "Li, Tong N" <tong.n.li@intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>, vatsa@in.ibm.com,
       balbir@in.ibm.com, Nick Piggin <npiggin@suse.de>,
       Bill Davidsen <davidsen@tmr.com>,
       John Kingman <kingman@storagegear.com>,
       Peter Williams <pwil3058@bigpond.net.au>, seuler.shi@gmail.com
Subject: Re: [RFC] Extend Linux to support proportional-share scheduling
Message-ID: <20070606033330.GB3266@1wt.eu>
References: <5FD5754DDBA0B1499B5A0B4BB54194850130685D@fmsmsx411.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5FD5754DDBA0B1499B5A0B4BB54194850130685D@fmsmsx411.amr.corp.intel.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tong,

On Tue, Jun 05, 2007 at 06:56:17PM -0700, Li, Tong N wrote:
> Hi all,
> 
> I've ported my code to mainline 2.6.21.3. You can get it at
> http://www.cs.duke.edu/~tongli/linux/.

as much as possible, you should post your patch for others to comment
on it. Posting just a URL is often fine to inform people that there's
an update to *try*, but at this stage, it may be more important to
comment on your design and code than trying it.

[...]

> Trio has two unique features: (1) it enables users to control shares of
> CPU time for any thread or group of threads (e.g., a process, an
> application, etc.), and (2) it enables fair sharing of CPU time across
> multiple CPUs. For example, with ten tasks running on eight CPUs, Trio
> allows each task to take an equal fraction of the total CPU time,

While this looks interesting, doesn't it make threads jump to random
CPUs all the time, thus reducing cache efficiency ? Or maybe it would
be good to consider two or three criteria to group CPUs :
  - those which share the same caches (multi-core)
  - those which share the same local memory on the same mainboard
    (multi-socket)
  - those which are so far away from each others that it's really
    not worth migrating a task

> whereas no existing scheduler achieves such fairness. These features
> enable Trio to complement the mainline scheduler and other proposals
> such as CFS and SD to enable greater user flexibility and stronger
> fairness.

Right now, I think that only benchmarks could tell which design is
better. I understand that running 10 tasks on 8 CPUs may result in
the last batch involving only 2 CPUs with 1 task each, thus increasing
the overall wall time. But maybe cache thrashing between CPUs will
also increase the wall time.

Regards,
Willy

