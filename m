Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbXFUQV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbXFUQV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 12:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbXFUQVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 12:21:51 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:57427 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbXFUQVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 12:21:50 -0400
Message-ID: <467AA596.5030509@s5r6.in-berlin.de>
Date: Thu, 21 Jun 2007 18:21:42 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: Greg K-H <greg@kroah.com>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       Adrian Bunk <bunk@stusta.de>, david@lang.hm,
       David Miller <davem@davemloft.net>,
       Duncan Sands <duncan.sands@math.u-psud.fr>,
       Phillip Susi <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] driver core: multithreaded probing - more parallelism
 control
References: <9D7649D18729DE4BB2BD7B494F7FEDC218022B@pdsmsx415.ccr.corp.intel.com>
In-Reply-To: <9D7649D18729DE4BB2BD7B494F7FEDC218022B@pdsmsx415.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> I think the queue IDs of different subsystem need not to be exclusive.
> The subsystem can allocate queue IDs arbitrarily. If one queue ID is
> shared between several subsystems, corresponding probing will be
> serialized. This will slow down the probing unnecessarily, but there
> will be no race condition.

Parallelism between subsystems may be interesting during boot ==
"coldplug", /if/ the machine has time-consuming devices to probe on
/different/ types of buses.  Of course some machines do the really
time-consuming stuff on only one type of bus.  Granted, parallelism
betwen subsystems is not very interesting anymore later after boot ==
"hotplug".

[...]
> Whether is it possible that a new unit is inserted during probing
> kthread is running.

Nodes and units on nodes may came and go at arbitrary points in time,
and I'm sure similar things can be said about the majority of other bus
architectures or network architectures.  We take this into account.

(The old FireWire stack will re-enter the main loop of the bus scanning
thread sometime after a bus reset event signaled that nodes or units may
have appeared or disappeared.  The new FireWire stack will schedule
respective scanning workqueue jobs after such an event.)
-- 
Stefan Richter
-=====-=-=== -==- =-=-=
http://arcgraph.de/sr/
