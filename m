Return-Path: <linux-kernel-owner+w=401wt.eu-S1750755AbXCLSFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750755AbXCLSFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 14:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750833AbXCLSFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 14:05:25 -0400
Received: from mail27.syd.optusnet.com.au ([211.29.133.168]:42221 "EHLO
	mail27.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750755AbXCLSFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 14:05:24 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Al Boldi <a1426z@gawab.com>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler
Date: Tue, 13 Mar 2007 05:05:04 +1100
User-Agent: KMail/1.9.5
Cc: ck list <ck@vds.kolivas.org>, linux-kernel@vger.kernel.org
References: <200703042335.26785.a1426z@gawab.com> <200703122352.51257.kernel@kolivas.org> <200703121714.25034.a1426z@gawab.com>
In-Reply-To: <200703121714.25034.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703130505.05132.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 March 2007 01:14, Al Boldi wrote:
> Con Kolivas wrote:
> > > > The higher priority one always get 6-7ms whereas the lower priority
> > > > one runs 6-7ms and then one larger perfectly bound expiration amount.
> > > > Basically exactly as I'd expect. The higher priority task gets
> > > > precisely RR_INTERVAL maximum latency whereas the lower priority task
> > > > gets RR_INTERVAL min and full expiration (according to the virtual
> > > > deadline) as a maximum. That's exactly how I intend it to work. Yes I
> > > > realise that the max latency ends up being longer intermittently on
> > > > the niced task but that's -in my opinion- perfectly fine as a
> > > > compromise to ensure the nice 0 one always gets low latency.
> > >
> > > I think, it should be possible to spread this max expiration latency
> > > across the rotation, should it not?
> >
> > There is a way that I toyed with of creating maps of slots to use for
> > each different priority, but it broke the O(1) nature of the virtual
> > deadline management. Minimising algorithmic complexity seemed more
> > important to maintain than getting slightly better latency spreads for
> > niced tasks. It also appeared to be less cache friendly in design. I
> > could certainly try and implement it but how much importance are we to
> > place on latency of niced tasks? Are you aware of any usage scenario
> > where latency sensitive tasks are ever significantly niced in the real
> > world?
>
> It only takes one negatively nice'd proc to affect X adversely.

I have an idea. Give me some time to code up my idea. Lack of sleep is making 
me very unpleasant.

-- 
-ck
