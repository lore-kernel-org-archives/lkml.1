Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1757195AbYLQMpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195AbYLQMpq (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:45:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753845AbYLQMpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:45:30 -0500
Received: from mga03.intel.com ([143.182.124.21]:18413 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622AbYLQMp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:45:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,236,1228118400"; 
   d="scan'208";a="91179449"
Date: Wed, 17 Dec 2008 20:44:21 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bill Davidsen <davidsen@tmr.com>
Subject: Re: 2.6.28-rc8 big regression in VM
Message-ID: <20081217124421.GA22317@localhost>
References: <20081212183810.GA4390@ics.muni.cz> <20081213012115.GA6250@localhost> <20081213095815.GA7143@ics.muni.cz> <20081215011645.GA9707@localhost> <20081215094409.GA4422@ics.muni.cz> <20081216045938.GA1000@localhost> <20081216195219.GA4480@ics.muni.cz> <20081217122726.GA21356@localhost> <20081217123307.GF4480@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217123307.GF4480@ics.muni.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 02:33:07PM +0200, Lukas Hejtmanek wrote:
> On Wed, Dec 17, 2008 at 08:27:26PM +0800, Wu Fengguang wrote:
> > It looks like most of cached pages were successfully freed:
> >
> >         247788 => 69856 pages
> >
> > To get more concrete numbers, could you send more info by running the
> > following commands?
> >
> > cp /proc/meminfo meminfo-1
> > cp /proc/vmstat vmstat-1
> > sync
> > echo 3 > /proc/sys/vm/drop_caches
> > cp /proc/meminfo meminfo-2
> > cp /proc/vmstat vmstat-2
>
> attached.

                    before            after
  MemTotal:        2016688 kB       2016688 kB
  MemFree:           22680 kB       1306652 kB
  Buffers:          238592 kB           360 kB
  Cached:          1087428 kB        129516 kB
----------------------------------------------
So the cache memory shrinks a lot.

Maybe your 'free' command is reporting wrong numbers?
Or it's not a quite reproducible problem?

Thanks,
Fengguang

  SwapCached:            0 kB             0 kB
  Active:          1016536 kB        428240 kB
  Inactive:         798812 kB        190976 kB
  Active(anon):     412044 kB        411084 kB
  Inactive(anon):   150708 kB        150708 kB
  Active(file):     604492 kB         17156 kB
  Inactive(file):   648104 kB         40268 kB
  Unevictable:           0 kB             0 kB
  Mlocked:               0 kB             0 kB
  SwapTotal:       1542232 kB       1542232 kB
  SwapFree:        1542232 kB       1542232 kB
  Dirty:               108 kB            48 kB
  Writeback:             0 kB             0 kB
  AnonPages:        489448 kB        489452 kB
  Mapped:            73380 kB         73384 kB
  Slab:             114192 kB         26188 kB
  SReclaimable:      97304 kB          9576 kB
  SUnreclaim:        16888 kB         16612 kB
  PageTables:        11304 kB         11368 kB
  NFS_Unstable:          0 kB             0 kB
  Bounce:                0 kB             0 kB
  WritebackTmp:          0 kB             0 kB
  CommitLimit:     2550576 kB       2550576 kB
  Committed_AS:     818488 kB        818488 kB
  VmallocTotal:   34359738367 kB   34359738367 kB

