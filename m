Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbYFDBTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbYFDBTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 21:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbYFDBS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 21:18:56 -0400
Received: from smtp111.mail.mud.yahoo.com ([209.191.84.64]:37342 "HELO
	smtp111.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752475AbYFDBS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 21:18:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=bmNMoYD78Mv2fMqt1Ep7pWmT5Nn4fsXKA6/UAtELh/5bu1azJOt12rC6yBtbkvhzdFc22NaxvrMOQC5AHde+wHmonFBeMe58b4TqlD3jcwvXHUb6D+qaJIhR1efCttplO9bobrdxJqd8RjdwBbyv2AYEUshH4C63jmRMnlof1dA=  ;
X-YMail-OSG: ObNuiIcVM1m5Xln5pPCiWim4VXm4jMyyAqjeCKNSAYFrUMDZNqe2azBfO__0MaCmMJJzzjHX1ddUPiaDA6AkP4rXdNdkpoU6XmmXghrRsbbAPLDWGQnBebXTFid99T0LJVc-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may have realtime uses)
Date: Wed, 4 Jun 2008 11:18:39 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Oeser <ioe-lkml@rameria.de>, Dimitri Sivanich <sivanich@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       "Derek L. Fults" <dfults@sgi.com>, devik <devik@cdi.cz>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Emmanuel Pacaud <emmanuel.pacaud@univ-poitiers.fr>,
       Frederik Deweerdt <deweerdt@free.fr>, Ingo Molnar <mingo@elte.hu>,
       Matthew Dobson <colpatch@us.ibm.com>, rostedt@goodmis.org,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Paul Menage <menage@google.com>, "Randy.Dunlap" <rddunlap@osdl.org>,
       suresh.b.siddha@intel.com, Thomas Gleixner <tglx@linutronix.de>
References: <20080601213019.14ea8ef8.pj@sgi.com> <4844BB41.7000605@qualcomm.com> <4845D825.6000403@qualcomm.com>
In-Reply-To: <4845D825.6000403@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806041118.40675.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 June 2008 09:47, Max Krasnyanskiy wrote:
> >> I would really appreciate some way to keep the kernel from using
> >> a CPU at all to do fault isolation. If possible not even booting it.
> >
> > How does isolcpu= boot option helps in this case ?
> > I suppose the closes option is maxcpus=. We can probably add ignorecpus=
> > or something to handle your use case but it has nothing to do with
> > isolcpus=.
>
> btw Ingo, I just realized that maxcpu= option is exactly what you need.
> Here is how you can use it.
> Boot your system with maxcpus=1. That way the kernel will only bring up
> processor 0. I'm assuming cpu0 is "good" otherwise your system is totally
> busted :). Other cpus will stay off-line and will not be initialized.
> Then once the system boots you can selectively bring "good" processors
> online by doing
> 	echo 1 > /sys/devices/system/cpu/cpuN/online
>
> This actually solves the case you're talking about (ie ignoring bad
> processors) instead of partially covering it with isolcpus=.

For your case, that's probably the best way to solve it, yes.


> Dimitri, you can probably use that too. ie Boot the thing with most CPUs
> offline and then bring them online. That way you'll know for sure that no
> timers, works, hard-/soft-irqs, etc are running on them.

When you bring a CPU online, in theory the sched domains should get
set up for them, so you should start seeing processes get migrated
onto it, and with them timers work queues etc.

If you have irqbalanced running, it probably migrates irqs onto them
as well if it needs to.
