Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbYAMEqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbYAMEqk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 23:46:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbYAMEqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 23:46:33 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:36337 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbYAMEqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 23:46:32 -0500
Date: Sun, 13 Jan 2008 10:16:07 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrea Righi <righiandr@users.sourceforge.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Valdis.Kletnieks@vt.edu,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC][PATCH] per-task I/O throttling
Message-ID: <20080113044607.GA13633@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Andrea Righi <righiandr@users.sourceforge.net>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>, Valdis.Kletnieks@vt.edu,
	LKML <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>
References: <47869FFE.1050000@users.sourceforge.net> <661de9470801110759h318347acw5f08c91b48ca742d@mail.gmail.com> <47879A32.8060508@users.sourceforge.net> <3777.1200113861@turing-police.cc.vt.edu> <1200131197.7999.14.camel@lappy> <20080112105702.GC25388@balbir.in.ibm.com> <1200136245.7999.20.camel@lappy> <4789006C.2030804@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4789006C.2030804@users.sourceforge.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrea Righi <righiandr@users.sourceforge.net> [2008-01-12 19:01:14]:

> Peter Zijlstra wrote:
> > On Sat, 2008-01-12 at 16:27 +0530, Balbir Singh wrote:
> >> * Peter Zijlstra <a.p.zijlstra@chello.nl> [2008-01-12 10:46:37]:
> >>
> >>> On Fri, 2008-01-11 at 23:57 -0500, Valdis.Kletnieks@vt.edu wrote:
> >>>> On Fri, 11 Jan 2008 17:32:49 +0100, Andrea Righi said:
> >>>>
> >>>>> The interesting feature is that it allows to set a priority for each
> >>>>> process container, but AFAIK it doesn't allow to "partition" the
> >>>>> bandwidth between different containers (that would be a nice feature
> >>>>> IMHO). For example it would be great to be able to define per-container
> >>>>> limits, like assign 10MB/s for processes in container A, 30MB/s to
> >>>>> container B, 20MB/s to container C, etc.
> >>>> Has anybody considered allocating based on *seeks* rather than bytes moved,
> >>>> or counting seeks as "virtual bytes" for the purposes of accounting (if the
> >>>> disk can do 50mbytes/sec, and a seek takes 5millisecs, then count it as 100K
> >>>> of data)?
> >>> I was considering a time scheduler, you can fill your time slot with
> >>> seeks or data, it might be what CFQ does, but I've never even read the
> >>> code.
> >>>
> >> So far the definition of I/O bandwidth has been w.r.t time. Not all IO
> >> devices have sectors; I'd prefer bytes over a period of time.
> > 
> > Doing a time based one would only require knowing the (avg) delay of
> > seeks, whereas doing a bytes based one would also require knowing the
> > (avg) speed of the device.
> > 
> > That is, if you're also interested in providing a latency guarantee.
> > Because that'd force you to convert bytes to time again.
> 
> So, what about considering both bytes/sec and io-operations/sec? In this
> way we should be able to limit huge streams of data and seek storms (or
> any mix of them).
> 
> Regarding CFQ, AFAIK it's only possible to configure an I/O priorty for
> a process, but there's no way for example to limit the bandwidth (or I/O
> operations/sec) for a particular user or group.
> 

Limiting usage is also a very useful feature. Andrea could you please
port your patches over to control groups.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
