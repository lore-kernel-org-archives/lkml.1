Return-Path: <linux-kernel-owner+w=401wt.eu-S1764368AbXE2Szx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764368AbXE2Szx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761505AbXE2Szn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:55:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:36069 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760374AbXE2Szm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:55:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,589,1170662400"; 
   d="scan'208";a="248486412"
Date: Tue, 29 May 2007 11:52:21 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] Make usb-autosuspend timer 1 sec jiffy aligned
Message-ID: <20070529185221.GA8852@linux-os.sc.intel.com>
References: <20070529175821.GA5411@linux-os.sc.intel.com> <20070529112230.c2687091.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070529112230.c2687091.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 11:22:30AM -0700, Randy Dunlap wrote:
> On Tue, 29 May 2007 10:58:21 -0700 Venki Pallipadi wrote:
> 
> > 
> > 
> > Below are a bunch of random timers, that were active on my system,
> > that can better be round_jiffies() aligned.
> 
> and these 4 patches help with (a) power usage, or (b) cache
> usage/niceness, or (c) other (be specific)...
> 

Yes. They are all related to power savings with tickless kernel.
A 5 sec timer account for 0.2 unnecessary wakeups per sec (powertop numbers).
All these patches together account for somewhere between 0.5-1
wakeup per second saving. That means my wakeups per second
comes down from ~18 per second to ~17 per second.
On my dual core laptop, CPUs will have more than 3% increase in
average C3 residency (actual powertop number went from ~104mS to ~108mS
long term C3 residency).

The actual AC power numbers were not consisitent enough to be reported here.
But, all these small changes will add up in terms of power savings and
battery life.

Thanks,
Venki
