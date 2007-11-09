Return-Path: <linux-kernel-owner+w=401wt.eu-S1761365AbXKINJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761365AbXKINJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 08:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbXKINJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 08:09:15 -0500
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:41585 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753226AbXKINJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 08:09:14 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=vkYMcRW07FU5HwsRtAV+OOIcKlJQNnfz3aF+YLp86IfgmzK33rA9gCbpiqg7Nm7/XK9bD1/bPbzZ9YeHayTGrH9DLD0l3xbtTNmbh+rBHswoad718Ot8jV2y3kQ9qY9anUXUgne/3K+5yALmAS63I/aEvK8P9Uw/404nxDKx6p0=  ;
X-YMail-OSG: Te4pqIAVM1kafGDoRtVgu17d0pNonKga9HsfxVSqWHU1ZnqZu3KDPutX5xtdCvSbVjm6CNwUbg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Gregory Haskins <gregory.haskins.ml@gmail.com>
Subject: Re: [PATCH] sched: avoid large irq-latencies in smp-balancing
Date: Sat, 10 Nov 2007 00:09:55 +1100
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Williams <pwil3058@bigpond.net.au>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <1194434956.6289.111.camel@twins> <1194437820.6289.114.camel@twins> <4732929D.604@gmail.com>
In-Reply-To: <4732929D.604@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711100009.56215.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 November 2007 15:37, Gregory Haskins wrote:
> Peter Zijlstra wrote:
> > Bah, missed a hunk
> >
> > ---
> > Subject: sched: avoid large irq-latencies in smp-balancing
> >
> > SMP balancing is done with IRQs disabled and can iterate the full rq.
> > When rqs are large this can cause large irq-latencies. Limit the nr of
> > iterations on each run.
> >
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > CC: Peter Williams <pwil3058@bigpond.net.au>
>
> Tested-by: Gregory Haskins <ghaskins@novell.com> (as part of 23.1-rt11)

OK, but let's not make this default for mainline just yet please. There
are so many performance regression possibilities in 2.6.24 already that
we should go a little bit slower for now IMO.
