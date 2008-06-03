Return-Path: <linux-kernel-owner+w=401wt.eu-S1756524AbYFCGEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbYFCGEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 02:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbYFCGD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 02:03:59 -0400
Received: from smtp119.mail.mud.yahoo.com ([209.191.84.76]:26005 "HELO
	smtp119.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753594AbYFCGD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 02:03:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=pzVbTFBE1bCognfko7bm1aIWkxYn5GPZnMjM2lVr+XtcVTTp3WRKITg1vcdq5OwUFmGa6mI4jFYOKD04WhaLEUcYwDYsfJRofyPydg0FkzZBHRqcd7LPlQ+1RgMjcljAxTwncn5fCbQw2mafgWr4AYA6v8eZKhW1CwmVXc7OoTU=  ;
X-YMail-OSG: 6o.MR00VM1nkeWPRu61PBuT8_7kZQnT1FBOQKF4nAyONGK4Chh3oqd_rYd3XsYPHfHI7nCP121K6jkseYsVCQd.w1ETjAa4OeDEp3DImPZrWBV4HxJQg_B3_rCsXRvgkKAU-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may have realtime uses)
Date: Tue, 3 Jun 2008 16:03:39 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Oeser <ioe-lkml@rameria.de>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       "Derek L. Fults" <dfults@sgi.com>, devik <devik@cdi.cz>,
       Dimitri Sivanich <sivanich@sgi.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Emmanuel Pacaud <emmanuel.pacaud@univ-poitiers.fr>,
       Frederik Deweerdt <deweerdt@free.fr>, Ingo Molnar <mingo@elte.hu>,
       Matthew Dobson <colpatch@us.ibm.com>,
       Max Krasnyansky <maxk@qualcomm.com>, rostedt@goodmis.org,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Paul Menage <menage@google.com>, "Randy.Dunlap" <rddunlap@osdl.org>,
       suresh.b.siddha@intel.com, Thomas Gleixner <tglx@linutronix.de>
References: <20080601213019.14ea8ef8.pj@sgi.com> <200806030035.58387.ioe-lkml@rameria.de> <1212446707.6269.26.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1212446707.6269.26.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806031603.40731.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 June 2008 08:45, Peter Zijlstra wrote:
> On Tue, 2008-06-03 at 00:35 +0200, Ingo Oeser wrote:
> > Hi Paul,
> >
> > in short: NAK!
> >
> > On Monday 02 June 2008, Paul Jackson wrote:
> > > (Aside to the RealTime folks -- is there a 'realtime'
> > > email list which I should include in this discussion?)
> > >
> > > The kernel has a "isolcpus=" kernel boot time parameter.  This
> > > parameter isolates CPUs from scheduler load balancing, minimizing the
> > > impact of scheduler latencies on realtime tasks running on those CPUs.
> >
> > I used it to mask out a defect CPU on a 8-CPU node of a
> > HPC-cluster at a customer site, until the $BIG_VENDOR
> > sent a replacement. And to prove $BIG_VENDOR, that we actually
> > have a problem on THAT CPU.
> >
> > So I would really like to keep this fault isolation capability.
> > I made my customer happy with that.
> >
> > I wish Linux had more such "mask out bad hardware" features
> > to faciliate fault isolation and boot and runtime.
>
> Yeah - except that its not meant to be used as such - it will still
> brings the cpu up, and it is still usable for the OS.
>
> So sorry, your abuse doesn't make for a case to keep this abomination.

How come it is an abonination? It is an easy way to do what it does,
and it's actually not a bad thing for some uses not to have to use
cpusets.

Given that it's all __init code anyway, is there a real reason _to_
remove it?
