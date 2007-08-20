Return-Path: <linux-kernel-owner+w=401wt.eu-S1761215AbXHTTNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761215AbXHTTNm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 15:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbXHTTNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 15:13:31 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:7087 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbXHTTNa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 15:13:30 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCPportsfrom the host TCP port space.
Date: Mon, 20 Aug 2007 12:02:25 -0700
Message-ID: <8A71B368A89016469F72CD08050AD334018E2149@maui.asicdesigners.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCPportsfrom the host TCP port space.
thread-index: AcfjTcsh70Yl6oErT6m2nBdPQyWDwgACy5sA
References: <20070819.174017.77241227.davem@davemloft.net><8A71B368A89016469F72CD08050AD334018E20BE@maui.asicdesigners.com><20070820094317.GA14817@2ka.mipt.ru><8A71B368A89016469F72CD08050AD334018E2115@maui.asicdesigners.com> <p73y7g6yt3j.fsf@bingen.suse.de>
From: "Felix Marti" <felix@chelsio.com>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>, <jeff@garzik.org>,
       <netdev@vger.kernel.org>, <rdreier@cisco.com>,
       <linux-kernel@vger.kernel.org>, <general@lists.openfabrics.org>,
       "David Miller" <davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: ak@suse.de [mailto:ak@suse.de] On Behalf Of Andi Kleen
> Sent: Monday, August 20, 2007 11:11 AM
> To: Felix Marti
> Cc: Evgeniy Polyakov; jeff@garzik.org; netdev@vger.kernel.org;
> rdreier@cisco.com; linux-kernel@vger.kernel.org;
> general@lists.openfabrics.org; David Miller
> Subject: Re: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate
> PS_TCPportsfrom the host TCP port space.
> 
> "Felix Marti" <felix@chelsio.com> writes:
> 
> > What I was referring to is that TSO(/LRO) have their own
> > issues, some eluded to by Roland and me. In fact, customers working
> on
> > the LSR couldn't use TSO due to the burstiness it introduces
> 
> That was in old kernels where TSO didn't honor the initial cwnd
> correctly,
> right? I assume it's long fixed.
> 
> If not please clarify what the problem was.
The problem is that is that Ethernet is about the only technology that
discloses 'useable' throughput while everybody else talks about
signaling rates ;) - OC-192 can carry about 9.128Gbps (or close to that
number) and hence 10Gbps Ethernet was overwhelming the OC-192 network.
The customer needed to schedule packets at about 98% of OC-192
throughput in order to avoid packet drop. The scheduling needed to be
done on a per packet basis and not per 'burst of packets' basis in order
to avoid packet drop.
 
> 
> > have a look at graphics.
> > Graphics used to be done by the host CPU and now we have dedicated
> > graphics adapters that do a much better job...
> 
> Is your off load device as programable as a modern GPU?
It has a lot of knobs to turn.

> 
> > farfetched that offload devices can do a better job at a data-flow
> > problem?
> 
> One big difference is that there is no potentially adverse and
> always varying internet between the graphics card and your monitor.
These graphic adapters provide a wealth of features that you can take
advantage of to bring these amazing graphics to life. General purpose
CPUs cannot keep up. Chelsio offload devices do the same thing in the
realm of networking. - Will there be things you can't do, probably yes,
but as I said, there are lots of knobs to turn (and the latest and
greatest feature that gets hyped up might not always be the best thing
since sliced bread anyway; what happened to BIC love? ;)

> 
> -Andi
