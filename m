Return-Path: <linux-kernel-owner+w=401wt.eu-S1758926AbYBINj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926AbYBINj0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 08:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757519AbYBINhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 08:37:47 -0500
Received: from mail.gmx.net ([213.165.64.20]:43240 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757417AbYBINhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 08:37:43 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18pdKlCiGQprPWXliHXgfmjbOGXS3wk6/x8/DQpbz
	udC5ErnDb1+CM/
Subject: Re: Scheduler(?) regression from 2.6.22 to 2.6.24 for short-lived
	threads
From: Mike Galbraith <efault@gmx.de>
To: Willy Tarreau <w@1wt.eu>
Cc: Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080209114009.GP8953@1wt.eu>
References: <20080209000456.GA21021@lixom.net>
	 <1202543920.9578.3.camel@homer.simson.net> <20080209080319.GO8953@1wt.eu>
	 <1202554705.10287.12.camel@homer.simson.net> <20080209114009.GP8953@1wt.eu>
Content-Type: text/plain
Date: Sat, 09 Feb 2008 14:37:39 +0100
Message-Id: <1202564259.4035.18.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-02-09 at 12:40 +0100, Willy Tarreau wrote: 
> On Sat, Feb 09, 2008 at 11:58:25AM +0100, Mike Galbraith wrote:
> > 
> > On Sat, 2008-02-09 at 09:03 +0100, Willy Tarreau wrote:
> > 
> > > How many CPUs do you have ?
> > 
> > It's a P4/HT, so 1 plus $CHUMP_CHANGE_MAYBE
> > 
> > > > 2.6.25-smp (git today)
> > > > time 29 ms
> > > > time 61 ms
> > > > time 72 ms
> > > 
> > > These ones look rather strange. What type of workload is it ? Can you
> > > publish the program for others to test it ?
> > 
> > It's the proglet posted in this thread.
> 
> OK sorry, I did not notice it when I first read the report.

Hm.  The 2.6.25-smp kernel is the only one that looks like it's doing
what proggy wants to do, massive context switching.  Bump threads to
larger number so you can watch: the supposedly good kernel (22) is doing
everything on one CPU.  Everybody else sucks differently (idleness), and
the clear throughput winner, via mad over-schedule (!?!), is git today.

	-Mike

