Return-Path: <linux-kernel-owner+w=401wt.eu-S1762854AbYALLKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762854AbYALLKv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 06:10:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761258AbYALLKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 06:10:41 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47988 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761248AbYALLKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 06:10:40 -0500
Subject: Re: [RFC][PATCH] per-task I/O throttling
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: balbir@linux.vnet.ibm.com
Cc: Valdis.Kletnieks@vt.edu, righiandr@users.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <20080112105702.GC25388@balbir.in.ibm.com>
References: <47869FFE.1050000@users.sourceforge.net>
	 <661de9470801110759h318347acw5f08c91b48ca742d@mail.gmail.com>
	 <47879A32.8060508@users.sourceforge.net>
	 <3777.1200113861@turing-police.cc.vt.edu> <1200131197.7999.14.camel@lappy>
	 <20080112105702.GC25388@balbir.in.ibm.com>
Content-Type: text/plain
Date: Sat, 12 Jan 2008 12:10:45 +0100
Message-Id: <1200136245.7999.20.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-01-12 at 16:27 +0530, Balbir Singh wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> [2008-01-12 10:46:37]:
> 
> > 
> > On Fri, 2008-01-11 at 23:57 -0500, Valdis.Kletnieks@vt.edu wrote:
> > > On Fri, 11 Jan 2008 17:32:49 +0100, Andrea Righi said:
> > > 
> > > > The interesting feature is that it allows to set a priority for each
> > > > process container, but AFAIK it doesn't allow to "partition" the
> > > > bandwidth between different containers (that would be a nice feature
> > > > IMHO). For example it would be great to be able to define per-container
> > > > limits, like assign 10MB/s for processes in container A, 30MB/s to
> > > > container B, 20MB/s to container C, etc.
> > > 
> > > Has anybody considered allocating based on *seeks* rather than bytes moved,
> > > or counting seeks as "virtual bytes" for the purposes of accounting (if the
> > > disk can do 50mbytes/sec, and a seek takes 5millisecs, then count it as 100K
> > > of data)?
> > 
> > I was considering a time scheduler, you can fill your time slot with
> > seeks or data, it might be what CFQ does, but I've never even read the
> > code.
> >
> 
> So far the definition of I/O bandwidth has been w.r.t time. Not all IO
> devices have sectors; I'd prefer bytes over a period of time.

Doing a time based one would only require knowing the (avg) delay of
seeks, whereas doing a bytes based one would also require knowing the
(avg) speed of the device.

That is, if you're also interested in providing a latency guarantee.
Because that'd force you to convert bytes to time again.

I'm not sure thats a good way to go with as long as a majority of
devices still have a non-0 seek penalty (SSDs just aren't there yet for
most of us).

