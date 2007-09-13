Return-Path: <linux-kernel-owner+w=401wt.eu-S1761887AbXIMVC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761887AbXIMVC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 17:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754319AbXIMVCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 17:02:21 -0400
Received: from 0006b10c8258.cranite.com ([63.81.170.2]:52657 "EHLO
	mailnode1.cranite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754065AbXIMVCU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 17:02:20 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: irq load balancing
Date: Thu, 13 Sep 2007 14:02:15 -0700
Message-ID: <3641F7C576757E49AE23AD0D820D72C434DCB8@mailnode1.cranite.com>
In-Reply-To: <20070913204443.GB5386@csclub.uwaterloo.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: irq load balancing
Thread-Index: Acf2RvENEOSCUc1AS4+n/bm4QPv1GwAAfLCw
From: "Venkat Subbiah" <venkats@cranite.com>
To: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Cc: "Chris Snook" <csnook@redhat.com>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since most network devices have a single status register for both
receiver and transmit (and errors and the like), which needs a lock to
protect access, you will likely end up with serious thrashing of moving
the lock between cpus.
> Any ways to measure the trashing of locks?

Since most network devices have a single status register for both
receiver and transmit (and errors and the like)
> These register accesses will be mostly within the irq handler which I
plan on keeping on the same processor. The network driver is actually
tg3. Will looks closely into the driver.

Thx,
Venkat


-----Original Message-----
From: Lennart Sorensen [mailto:lsorense@csclub.uwaterloo.ca] 
Sent: Thursday, September 13, 2007 1:45 PM
To: Venkat Subbiah
Cc: Chris Snook; linux-kernel@vger.kernel.org
Subject: Re: irq load balancing

On Thu, Sep 13, 2007 at 01:31:39PM -0700, Venkat Subbiah wrote:
> Doing it in a round-robin fashion will be disastrous for performance.
> Your cache miss rate will go through the roof and you'll hit the slow
> paths in the network stack most of the time.
> > Most of the work in my system is spent in enrypt/decrypting traffic.
> Right now all this is done in a tasklet within the softirqd and hence
> all landing up on the same CPU.
> On the receive side it'a packet handler that handles the traffic. On
the
> tx side it's done within the transmit path of the packet. So would
> re-architecting this to move the rx packet handler to a different
kernel
> thread(with smp affinity to one CPU) and tx to a different kernel
> thread(with SMP affinity to a different CPU) be advisable. 
> What's the impact on cache miss and slowpath/fastpath in network
stack.

Since most network devices have a single status register for both
receiver and transmit (and errors and the like), which needs a lock to
protect access, you will likely end up with serious thrashing of moving
the lock between cpus.

--
Len Sorensen
