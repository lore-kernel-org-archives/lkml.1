Return-Path: <linux-kernel-owner+w=401wt.eu-S1758131AbZJFPtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131AbZJFPtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758051AbZJFPtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:49:41 -0400
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:54378 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757737AbZJFPtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:49:40 -0400
From: Frans Pop <elendil@planet.nl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [.32-rc3] scheduler: iwlagn consistently high in "waiting for CPU"
Date: Tue, 6 Oct 2009 17:49:01 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-wireless@vger.kernel.org
References: <200910051500.55875.elendil@planet.nl> <200910051613.32631.elendil@planet.nl> <20091005072428.16ce40e4@infradead.org>
In-Reply-To: <20091005072428.16ce40e4@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910061749.02805.elendil@planet.nl>
X-OriginalArrivalTime: 06 Oct 2009 15:49:03.0339 (UTC) FILETIME=[875DBBB0:01CA469C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 October 2009, Arjan van de Ven wrote:
> On Mon, 5 Oct 2009 16:13:31 +0200 Frans Pop <elendil@planet.nl> wrote:
> > On Monday 05 October 2009, Frans Pop wrote:
> > > With .32-rc3 I'm getting occasional skips from amarok while playing
> > > music from an NFS share (3 today so far), something I've not had in
> > > a long time.
> > >
> > > The reason looks to be that latencytop consistently shows 'iwlagn'
> > > as the top affected process with "Scheduler: waiting for CPU".
> > > Values of 100-140 ms occur frequently, but I've also seen higher
> > > values (180, 207). I don't remember seeing iwlagn high in the list
> > > before, but I have not checked earlier kernels yet.
> > >
> > > Added to that 'phy0' also frequently shows high with values of
> > > 25-75 ms.

I've checked for 2.6.31.1 now and iwlagn is listed high there too when the 
system is idle, but with normal values of 60-100 ms. And phy0 has normal 
values of below 10 ms.
I've now rebooted with today's mainline git; phy0 now frequently shows with 
values of around 100 ms too (i.e. higher than last time).

Both still go way down as soon as the system is given work to do.

> > If I give the system some work to do (like compiling a kernel), the
> > latencies on iwlagn and phy0 disappear (values < 5 ms).
> > Is this related to ondemand frequency scaling?
>
> shouldn't be.... but
>
> can you do a 5 second or so timechart recording of this?
> That will capture all scheduler delays as well as the P states etc....

With a 5 second sleep I was unable to get any significant latencies (I 
started perf on a latencytop refresh and did a manual refresh as it 
finished to see what happened during the perf run). The perf run does seem 
to affect the latencies.
I've uploaded a chart for a 10s sleep during which I got latencies of 101ms 
for iwlagn and 77ms for phy0: http://people.debian.org/~fjp/tmp/kernel/.

I've also uploaded the raw data as the colors in the chart looked off to me 
(CPU bars were mostly black in Debian unstable's inkscape). I can't make 
much from the chart TBH, but maybe you can.

Not sure what to do with this. For now I'd suggest to ignore it as it's all 
a bit vague. Unless of course you feel the latencies are higher than they 
should be.
I'll see if I get more skips and what latencies I get during them.

Cheers,
FJP
