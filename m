Return-Path: <linux-kernel-owner+w=401wt.eu-S1758900AbXGCJeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758900AbXGCJeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 05:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756092AbXGCJdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 05:33:55 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:21435 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906AbXGCJdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 05:33:54 -0400
Date: Tue, 3 Jul 2007 11:33:52 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: "Huang, Ying" <ying.huang@intel.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Adrian Bunk <bunk@stusta.de>, david@lang.hm,
       David Miller <davem@davemloft.net>,
       Duncan Sands <duncan.sands@math.u-psud.fr>,
       Phillip Susi <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] driver core: multithreaded probing - more
 parallelismcontrol
Message-ID: <20070703113352.600da16a@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070625081624.GB23847@kroah.com>
References: <20070624070601.GB24941@kroah.com>
	<9D7649D18729DE4BB2BD7B494F7FEDC2180928@pdsmsx415.ccr.corp.intel.com>
	<20070625081624.GB23847@kroah.com>
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

On Mon, 25 Jun 2007 01:16:24 -0700,
Greg KH <greg@kroah.com> wrote:

[I'm a bit late to the party, but...]

> On Sun, Jun 24, 2007 at 11:04:13PM +0800, Huang, Ying wrote:

> > There does exist multithreaded device probing in current driver core
> > implementation, supposing two devices are hot-plugged at the same time.
> 
> No, that is a bus-specific thing, and no bus that I know of supports
> that at this time.

The s390 channel subsystem busses should be fine with any parallelism,
especially as the css bus kicks off tons of probes (device recognition)
at the same time. Any ccw driver must be able to be handle to be called
for many devices in parallel as well (like, when someone attaches their
shiny new storage subsystem to the LPAR and some thousands of dasds
become available).

> 
> > But, many device drivers are written without this taken into account.
> 
> That's why no bus does this :)

It is possible for busses for a small set of device drivers (like the
s390 busses; maybe there are others). It looks like a bad idea to try
this for PCI :)

> 
> > I think it may be better to make default device probing process more
> > single-threaded in the driver core. The single-thread workqueue or some
> > customized version of workqueue like that implemented by my patch can be
> > used for this. The parallel control mechanism can be used to implement
> > multithreaded device probing in needed subsystems too.
> 
> But remember, the individual busses already do this all in a single
> thread anyway, nothing is needed in the driver core to do this.

I think I could make good use of some more parallelism control (for
throttling or so). Not sure if it should really sit at the driver
core level, but that would avoid reinventing the wheel.

[Goes reading the original patch]

Cornelia
