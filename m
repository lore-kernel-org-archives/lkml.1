Return-Path: <linux-kernel-owner+w=401wt.eu-S1752047AbXIPEIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbXIPEIk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 00:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbXIPEId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 00:08:33 -0400
Received: from 1wt.eu ([62.212.114.60]:2506 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbXIPEIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 00:08:32 -0400
Date: Sun, 16 Sep 2007 06:08:29 +0200
From: Willy Tarreau <w@1wt.eu>
To: David Schwartz <davids@webmaster.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CPU usage for 10Gbps UDP transfers
Message-ID: <20070916040829.GC10199@1wt.eu>
References: <20070915190016.GA3868@ics.muni.cz> <MDEHLPKNGKAHNMBLJOLKMECDGNAC.davids@webmaster.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKMECDGNAC.davids@webmaster.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 15, 2007 at 04:29:39PM -0700, David Schwartz wrote:
> 
> > Hello,
> >
> > is it expected that application sending 8900bytes datagram
> > through 10Gbps NIC
> > utilizes CPU to 100% and similarly the receiver also utilizes CPU to 100%.
> > Is it something wrong or this is quite OK?
> >
> > (The box is dual single core Opteron 2.4GHz with Myricom 10GE NIC.)
> 
> It's extremely hard to understand what it is that you're saying. Perhaps if
> I explain the two things I first thought when you posted this, it will
> explain why your post is vague:
> 
> 1) *Any* task will use the CPU to 100% while it's running. Even if you ask
> the computer to add 1 to 1, while it's doing that add for you, the task is
> using 100% of the CPU.
> 
> 2) If you ask the CPU to do any task over and over again as quickly as it
> can, and it has nothing else to do, that task will get 100% of the CPU?
> 
> So what are you really asking?

I think he means that his application saturates the 10Gbps NIC with 8900
bytes datagrams and it consumes 100% of the CPU while doing this, and it's
the same on the receiver side. I'm not surprized at all, considering that
it means around 140kpps, or pauses of about 7 microseconds between each
frame. Those pauses are too short to do anything else, resulting in the
task to appear as taking 100% CPU. But IMHO, that does not mean that the
machine is saturated; If the task had more work to do between each datagram,
it would possibly be done. Same if it had to send shorter frames twice as
fast.

Willy

