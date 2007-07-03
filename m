Return-Path: <linux-kernel-owner+w=401wt.eu-S1760716AbXGCPEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760716AbXGCPEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 11:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760629AbXGCPEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 11:04:33 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:11348 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760625AbXGCPEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 11:04:32 -0400
Date: Tue, 3 Jul 2007 17:04:30 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Greg K-H <greg@kroah.com>,
       Adrian Bunk <bunk@stusta.de>, david@lang.hm,
       David Miller <davem@davemloft.net>,
       Duncan Sands <duncan.sands@math.u-psud.fr>,
       Phillip Susi <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] driver core: multithreaded probing - more parallelism
 control
Message-ID: <20070703170430.751f4f93@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <1182505958.12161.0.camel@caritas-dev.intel.com>
References: <9D7649D18729DE4BB2BD7B494F7FEDC218022B@pdsmsx415.ccr.corp.intel.com>
	<467AA596.5030509@s5r6.in-berlin.de>
	<1182505958.12161.0.camel@caritas-dev.intel.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.13; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007 09:52:38 +0000,
"Huang, Ying" <ying.huang@intel.com> wrote:

> On Thu, 2007-06-21 at 18:21 +0200, Stefan Richter wrote:
> > Parallelism between subsystems may be interesting during boot ==
> > "coldplug", /if/ the machine has time-consuming devices to probe on
> > /different/ types of buses.  Of course some machines do the really
> > time-consuming stuff on only one type of bus.  Granted, parallelism
> > betwen subsystems is not very interesting anymore later after boot ==
> > "hotplug".
> 
> Yes. So I think there are two possible solution.
> 
> 1. Creating one set of probing queues for each subsystem (maybe just the
> subsystems need it), so the probing queue IDs are local to each
> subsystem.
> 2. There is only one set of probing queues in whole system. The probing
> queue IDs are shared between subsystems. The subsystem can select a
> random starting queue ID (maybe named as start_queue_id), and allocate
> the queue IDs from that point on (start_queue_id + private_queue_id). So
> the probability of queue ID sharing will be reduced.

What should also be considered here is that we may want to have
different numbers of queues per subsystem (fewer for those where
probing is resource-heavy), but may want to restrict the total number
of queues as well. Some throttling mechanism may be helpful here (so
that a single subsystem cannot hog all queues while another is stuck
with a single queue, or double usage of queues). In fact, throttling
may be interesting for any subsystem using parallelism, especially if
the number of devices may be huge and/or probing resource hungry.

Cornelia
