Return-Path: <linux-kernel-owner+w=401wt.eu-S1767171AbXCILEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767171AbXCILEj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 06:04:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767173AbXCILEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 06:04:38 -0500
Received: from z2.cat.iki.fi ([212.16.98.133]:51567 "EHLO z2.cat.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767171AbXCILEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 06:04:38 -0500
Date: Fri, 9 Mar 2007 13:04:36 +0200
From: Matti Aarnio <matti.aarnio@zmailer.org>
To: Niklaus <niklaus@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: more than 65535 outbound connections
Message-ID: <20070309110436.GD3883@mea-ext.zmailer.org>
References: <85e0e3140703090016h609ecc5t504121a99bcd3e44@mail.gmail.com> <85e0e3140703090019r7daf5ce4g9269925773374bf7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85e0e3140703090019r7daf5ce4g9269925773374bf7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 01:49:34PM +0530, Niklaus wrote:
> Hi,
> 
> I could be wrong in the below description or might have misunderstood
> many of the concepts , please correct appropriately.
> 
> 65535 ports can allowed . So on a  machine namely C you can have max
> 65535 outbound connections

IP connections are quads (four-tuples), machine A and B IP addresses,
plus 16 bit port numbers at both ends.

You can have about  64 k * 3 G = 192 T  connections out from a machine
to any single port number out there to all existing IP addresses.

If  A.ip, B.ip, and B.port  stay the same, A can setup up to some
10 - 50 thousand parallel connections.  (Depending on allowed dynamic
source IP port number space at machine A.)

If either B.ip or B.port changes, A can reuse a port that is actively
connected to something. Resulting four-tuple is different -> connection
is different.

Does Linux reuse port numbers in this way ?
It most likely does, but I didn't verify.

> What i was thinking was to send to another machines A and B from the
> same port [X] and then when we get data from it to [X] we can the send
> it to the correct application using stateful mapping or storing some
> information . The machines A and B are unaware of this mapping from
> the C  machine.

You want to make a "L4 switch" -- a "load balancer" ?
That thing is a NAT-box, and is really not making buffered TCP flows,
but rather mapping IP/TCP header rewriters to divert the flows to new
destinations.

> Can we increase it by anymeans in the kernel. Does we have patches for the 
> above
> 
> i read on the web that terry lambert has got 1.6 million simultaneous
> connection ? how is the way it is done.
> 
> http://kerneltrap.org/node/277

With 50 thousand connections per single ( A.ip / B.ip / B.port ) set,
one needs only 32  B.ports or A.ip:s or B.ip:s to do that 1.6 million
parallel TCP streams.

Such does eat up lots and lots system kernel memory...

> Regs
> Nik

/Matti Aarnio

