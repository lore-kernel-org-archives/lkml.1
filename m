Return-Path: <linux-kernel-owner+w=401wt.eu-S1756403AbYCKLuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403AbYCKLuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 07:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbYCKLud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 07:50:33 -0400
Received: from phunq.net ([64.81.85.152]:55142 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750959AbYCKLuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 07:50:32 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Tue, 11 Mar 2008 03:50:18 -0800
User-Agent: KMail/1.9.5
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Grzegorz Kulewski <kangur@polcom.net>,
       linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803110414.40954.phillips@phunq.net> <20080311112329.GR1581@marowsky-bree.de>
In-Reply-To: <20080311112329.GR1581@marowsky-bree.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803110450.19390.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 March 2008 04:23, Lars Marowsky-Bree wrote:
> If I always assume a reliable shutdown - UPS protected, no crashes, etc
> - you're right, but at least my real world has other failure scenarios
> as well. In fact, the most common reason for unorderly shutdowns are
> kernel crashes, not power failures in my experience.

What are you doing to your kernel?

My desktop at home, which runs my MTA, web site etc, and is subject to
regular oom abuse by firefox:

$ uptime
04:36:49 up 204 days,  9:38,  8 users,  load average: 0.82, 0.43, 0.20

This machine has been up ever since I got a UPS for it, and then it
only ever went down due to a blackout or my wife blowing a fuse with
the vacuum cleaner.  Honestly, I have never seen a machine running
Linux 2.6 crash due to a software flaw, except when I caused it
myself.  I suspect the Linux kernel has a better MTBF than a hard
disk.

> So "perfectly reliable if UPS power does not fail" seems a bit over the
> top.

It works for EMC :-)

> I was trying to prod you into writing the ordered flushing. Maybe
> claiming it is too hard will do the trick? ;-)
> 
> Seriously, I guess it depends on the workload you want to host.

I agree this would be a nice option to have.

> > If you think this is like replication then you have the wrong idea
> > about what is going on.  This is a cache consistency algorithm, not
> > a replication algorithm.
> 
> I see the differences, but I also see the similarities. What you're
> doing can also be thought of as replicating from an instant IO store
> (local memory) to a high latency, low bandwidth copy (the disk)
> asynchronously.
> 
> Both obviously need to preserve consistency, the question is whether to
> achieve transactional (ordered) consistency or not.

In fact, replicating was one of the strategies I considered for this.
But since it is a lot more work and will not perform as well as a
simple sweep, I opted for the simple thing.  Which turned out to
be pretty complex anyway.  You have to close all the same nasty
races but with a considerably more complex base algorithm.  I think
that better wait for version 2.0.

By the way, I could use a hand debugging this thing.

Regards,

Daniel
