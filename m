Return-Path: <linux-kernel-owner+w=401wt.eu-S933420AbXIMUox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933420AbXIMUox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 16:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757595AbXIMUop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 16:44:45 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:44569 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757109AbXIMUoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 16:44:44 -0400
Date: Thu, 13 Sep 2007 16:44:43 -0400
To: Venkat Subbiah <venkats@cranite.com>
Cc: Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: irq load balancing
Message-ID: <20070913204443.GB5386@csclub.uwaterloo.ca>
References: <46E85DDA.7010209@redhat.com> <3641F7C576757E49AE23AD0D820D72C434DCB3@mailnode1.cranite.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3641F7C576757E49AE23AD0D820D72C434DCB3@mailnode1.cranite.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 01:31:39PM -0700, Venkat Subbiah wrote:
> Doing it in a round-robin fashion will be disastrous for performance.
> Your cache miss rate will go through the roof and you'll hit the slow
> paths in the network stack most of the time.
> > Most of the work in my system is spent in enrypt/decrypting traffic.
> Right now all this is done in a tasklet within the softirqd and hence
> all landing up on the same CPU.
> On the receive side it'a packet handler that handles the traffic. On the
> tx side it's done within the transmit path of the packet. So would
> re-architecting this to move the rx packet handler to a different kernel
> thread(with smp affinity to one CPU) and tx to a different kernel
> thread(with SMP affinity to a different CPU) be advisable. 
> What's the impact on cache miss and slowpath/fastpath in network stack.

Since most network devices have a single status register for both
receiver and transmit (and errors and the like), which needs a lock to
protect access, you will likely end up with serious thrashing of moving
the lock between cpus.

--
Len Sorensen
