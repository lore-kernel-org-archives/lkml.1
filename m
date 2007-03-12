Return-Path: <linux-kernel-owner+w=401wt.eu-S965636AbXCLLXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965636AbXCLLXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 07:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965625AbXCLLXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 07:23:14 -0400
Received: from [212.12.190.74] ([212.12.190.74]:32898 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S965646AbXCLLXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 07:23:13 -0400
From: Al Boldi <a1426z@gawab.com>
To: Con Kolivas <kernel@kolivas.org>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler
Date: Mon, 12 Mar 2007 14:26:00 +0300
User-Agent: KMail/1.5
Cc: ck list <ck@vds.kolivas.org>, linux-kernel@vger.kernel.org
References: <200703042335.26785.a1426z@gawab.com> <200703120742.41041.a1426z@gawab.com> <200703121553.30462.kernel@kolivas.org>
In-Reply-To: <200703121553.30462.kernel@kolivas.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200703121426.00854.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> On Monday 12 March 2007 15:42, Al Boldi wrote:
> > Con Kolivas wrote:
> > > On Monday 12 March 2007 08:52, Con Kolivas wrote:
> > > > And thank you! I think I know what's going on now. I think each
> > > > rotation is followed by another rotation before the higher priority
> > > > task is getting a look in in schedule() to even get quota and add it
> > > > to the runqueue quota. I'll try a simple change to see if that
> > > > helps. Patch coming up shortly.
> > >
> > > Can you try the following patch and see if it helps. There's also one
> > > minor preemption logic fix in there that I'm planning on including.
> > > Thanks!
> >
> > Applied on top of v0.28 mainline, and there is no difference.
> >
> > What's it look like on your machine?
>
> The higher priority one always get 6-7ms whereas the lower priority one
> runs 6-7ms and then one larger perfectly bound expiration amount.
> Basically exactly as I'd expect. The higher priority task gets precisely
> RR_INTERVAL maximum latency whereas the lower priority task gets
> RR_INTERVAL min and full expiration (according to the virtual deadline) as
> a maximum. That's exactly how I intend it to work. Yes I realise that the
> max latency ends up being longer intermittently on the niced task but
> that's -in my opinion- perfectly fine as a compromise to ensure the nice 0
> one always gets low latency.

I think, it should be possible to spread this max expiration latency across 
the rotation, should it not?


Thanks!

--
Al

