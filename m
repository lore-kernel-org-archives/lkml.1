Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbXHSTur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbXHSTur (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 15:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754544AbXHSTug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 15:50:36 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:15814 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbXHSTuf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 15:50:35 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCPportsfrom the host TCP port space.
Date: Sun, 19 Aug 2007 12:49:05 -0700
Message-ID: <8A71B368A89016469F72CD08050AD334018E209C@maui.asicdesigners.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCPportsfrom the host TCP port space.
thread-index: Acfil3YhV6o+rYB9TQS3qrkqOsWPzQAACd4Q
References: <000001c7e22e$b7b90f00$29c8180a@amr.corp.intel.com><20070819.002337.06589160.davem@davemloft.net><8A71B368A89016469F72CD08050AD334018E208F@maui.asicdesigners.com> <20070819.123212.13769462.davem@davemloft.net>
From: "Felix Marti" <felix@chelsio.com>
To: "David Miller" <davem@davemloft.net>
Cc: <sean.hefty@intel.com>, <netdev@vger.kernel.org>, <rdreier@cisco.com>,
       <general@lists.openfabrics.org>, <linux-kernel@vger.kernel.org>,
       <jeff@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Sunday, August 19, 2007 12:32 PM
> To: Felix Marti
> Cc: sean.hefty@intel.com; netdev@vger.kernel.org; rdreier@cisco.com;
> general@lists.openfabrics.org; linux-kernel@vger.kernel.org;
> jeff@garzik.org
> Subject: Re: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate
> PS_TCPportsfrom the host TCP port space.
> 
> From: "Felix Marti" <felix@chelsio.com>
> Date: Sun, 19 Aug 2007 10:33:31 -0700
> 
> > I know that you don't agree that TSO has drawbacks, as outlined by
> > Roland, but its history showing something else: the addition of TSO
> > took a fair amount of time and network performance was erratic for
> > multiple kernel revisions and the TSO code is sprinkled across the
> > network stack.
> 
> This thing you call "sprinkled" is a necessity of any hardware
> offload when it is possible for a packet to later get "steered"
> to a device which cannot perform the offload.
> 
> Therefore we need a software implementation of TSO so that those
> packets can still get output to the non-TSO-capable device.
> 
> We do the same thing for checksum offloading.
> 
> And for free we can use the software offloading mechanism to
> get batching to arbitrary network devices, even those which cannot
> do TSO.
> 
> What benefits does RDMA infrastructure give to non-RDMA capable
> devices?  None?  I see, that's great.
> 
> And again the TSO bugs and issues are being overstated and, also for
> the second time, these issues are more indicative of my bad
> programming skills then they are of intrinsic issues of TSO.  The
> TSO implementation was looking for a good design, and it took me
> a while to find it because I personally suck.
> 
> Face it, stateless offloads are always going to be better in the long
> term.  And this is proven.
> 
> You RDMA folks really do live in some kind of fantasy land.
[Felix Marti] You're not at all addressing the fact that RDMA does solve
the memory BW problem and stateless offload doesn't. Apart from that, I
don't quite understand your argument with respect to the benefits of the
RDMA infrastructure; what benefits does the TSO infrastructure give the
non-TSO capable devices? Isn't the answer none and yet you added TSO
support?! I don't think that the argument is stateless _versus_ stateful
offload both have their advantages and disadvantages. Stateless offload
does help, i.e. TSO/LRO do improve performance in back-to-back
benchmarks. It seems me that _you_ claim that there is no benefit to
statefull offload and that is where we're disagreeing; there is benefit
and i.e. the much lower memory BW requirements is just one example, yet
an important one. We'll probably never agree but it seems to me that
we're asking only for small changes to the software stack and then we
can give the choice to the end users: they can opt for stateless offload
if it fits the performance needs or for statefull offload if their apps
require the extra boost in performance.

