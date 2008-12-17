Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753251AbYLQM2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbYLQM2l (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751046AbYLQM2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:28:31 -0500
Received: from mga14.intel.com ([143.182.124.37]:2560 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916AbYLQM2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:28:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,236,1228118400"; 
   d="scan'208";a="91174371"
Date: Wed, 17 Dec 2008 20:27:26 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bill Davidsen <davidsen@tmr.com>
Subject: Re: 2.6.28-rc8 big regression in VM
Message-ID: <20081217122726.GA21356@localhost>
References: <20081212183810.GA4390@ics.muni.cz> <20081213012115.GA6250@localhost> <20081213095815.GA7143@ics.muni.cz> <20081215011645.GA9707@localhost> <20081215094409.GA4422@ics.muni.cz> <20081216045938.GA1000@localhost> <20081216195219.GA4480@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081216195219.GA4480@ics.muni.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 09:52:19PM +0200, Lukas Hejtmanek wrote:
> On Tue, Dec 16, 2008 at 12:59:38PM +0800, Wu Fengguang wrote:
> > > > modprobe filecache
> > > > free; cp /proc/filecache /tmp/a;
> > > > echo 3 > /proc/sys/vm/drop_caches
> > > > free; cp /proc/filecache /tmp/b;
> > > > 
> > > > and send me the outputs a and b?
> > > 
> > > unfortunately, it causes an oops (0000 [#1] SMP) in d_path + 0x31/0x110, code
> > > 48 85 c0 74 2f <48> 8b 40 30 48
> > > rax = 0x100000001
> > > 
> > > (it does not save the oops into any log, thus I only wrote down possibly most
> > > important clues)
> > 
> > Sorry I made a silly mistake while rebasing the patch to 2.6.28.
> > The attached patch works OK here.
> 
> so, here are the files.

Thank you.

It looks like most of cached pages were successfully freed:

        247788 => 69856 pages

To get more concrete numbers, could you send more info by running the
following commands?

cp /proc/meminfo meminfo-1
cp /proc/vmstat vmstat-1
sync
echo 3 > /proc/sys/vm/drop_caches
cp /proc/meminfo meminfo-2
cp /proc/vmstat vmstat-2

Thanks,
Fengguang
