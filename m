Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbXLGASR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbXLGASR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 19:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbXLGASH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 19:18:07 -0500
Received: from lec.cs.unibo.it ([130.136.1.103]:57716 "EHLO lec.cs.unibo.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739AbXLGASG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 19:18:06 -0500
Date: Fri, 7 Dec 2007 01:18:03 +0100
To: Andi Kleen <andi@firstfloor.org>
Cc: Chris Friesen <cfriesen@nortel.com>, linux-kernel@vger.kernel.org
Subject: Re: New Address Family: Inter Process Networking (IPN)
Message-ID: <20071207001803.GA9330@cs.unibo.it>
References: <20071205164055.GA2082@cs.unibo.it> <p73bq94k8yd.fsf@bingen.suse.de> <20071206053016.GA1464@cs.unibo.it> <20071206163538.GC20595@one.firstfloor.org> <47585D66.3000404@nortel.com> <20071206212644.GA26725@one.firstfloor.org> <47586E7F.1020903@nortel.com> <20071206220754.GF20595@one.firstfloor.org> <20071206221837.GE30293@cs.unibo.it> <20071206223823.GH20595@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071206223823.GH20595@one.firstfloor.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: renzo@cs.unibo.it (Renzo Davoli)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have done some raw tests.
(you can read the code here: http://www.cs.unibo.it/~renzo/rawperftest/)

The programs are quite simple. The sender sends "Hello World" as fast as it
can, while the receiver prints time() for each 1 million message
received.

On my laptop, tests on 20000000 "Hello World" packets, 

One receiver:
multicast	244,000 msg/sec
IPN             333,000 msg/sec  (36% faster)

Two receivers:
multicast       174,000 msg/sec
IPN             250,000 msg/sec  (43% faster)

Apart from this, how could I implement policies over a multicast socket,
e.g. how does a Kernel VDE_switch work on multicast sockets?

If I send an ethernet packet over a multicast socket it can emulate just a
hub (Although it seems to me quite innatural to have to have TCP-UDP 
over IP over Ethernet over UDP over IP - okay we can skip the Ethernet 
on localhost, long ethernet frames get fragmentated but... details).

On multicast socket you cannot use policies, I mean a IPN network (or
bus or group) can have a policy reading some info on the packet to
decide the set of receipients.
For a vde_switch it is the destination mac address when found in the
MAC hash table to select the receipient port. For midi communication it 
could be the channel number....

Moving the switching fabric to the userland the performance figures are
quite different.

renzo

