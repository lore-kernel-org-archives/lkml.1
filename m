Return-Path: <linux-kernel-owner+w=401wt.eu-S1750714AbXCLS6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750714AbXCLS6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 14:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbXCLS6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 14:58:11 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:38730 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbXCLS6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 14:58:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YrYV2nQpA5kz7s4nqzyQmS4+oopr/l28nOUFL0+dmCdCFgNaKG+uQZACI10nEZXsLbafcwfCpmvSnyciZrWkyNvIATBBSoqlxkYVcV+hulnx37UkemhuEEs9HOYNCYYZnddK70qH7Nw0NkaLk4TOWSC94Eba4ynSMEVBqLqjJJo=
Message-ID: <69304d110703121158y32e23e85i2896763d04231f0d@mail.gmail.com>
Date: Mon, 12 Mar 2007 19:58:05 +0100
From: "Antonio Vargas" <windenntw@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [ck] Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler
Cc: ck@vds.kolivas.org, "Al Boldi" <a1426z@gawab.com>,
       "Con Kolivas" <kernel@kolivas.org>, "jos poortvliet" <jos@mijnkamer.nl>
In-Reply-To: <200703121947.16008.jos@mijnkamer.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703042335.26785.a1426z@gawab.com>
	 <200703121714.25034.a1426z@gawab.com>
	 <200703130505.05132.kernel@kolivas.org>
	 <200703121947.16008.jos@mijnkamer.nl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/07, jos poortvliet <jos@mijnkamer.nl> wrote:
> Op Monday 12 March 2007, schreef Con Kolivas:
> > On Tuesday 13 March 2007 01:14, Al Boldi wrote:
> > > Con Kolivas wrote:
> > > > > > The higher priority one always get 6-7ms whereas the lower priority
> > > > > > one runs 6-7ms and then one larger perfectly bound expiration
> > > > > > amount. Basically exactly as I'd expect. The higher priority task
> > > > > > gets precisely RR_INTERVAL maximum latency whereas the lower
> > > > > > priority task gets RR_INTERVAL min and full expiration (according
> > > > > > to the virtual deadline) as a maximum. That's exactly how I intend
> > > > > > it to work. Yes I realise that the max latency ends up being longer
> > > > > > intermittently on the niced task but that's -in my opinion-
> > > > > > perfectly fine as a compromise to ensure the nice 0 one always gets
> > > > > > low latency.
> > > > >
> > > > > I think, it should be possible to spread this max expiration latency
> > > > > across the rotation, should it not?
> > > >
> > > > There is a way that I toyed with of creating maps of slots to use for
> > > > each different priority, but it broke the O(1) nature of the virtual
> > > > deadline management. Minimising algorithmic complexity seemed more
> > > > important to maintain than getting slightly better latency spreads for
> > > > niced tasks. It also appeared to be less cache friendly in design. I
> > > > could certainly try and implement it but how much importance are we to
> > > > place on latency of niced tasks? Are you aware of any usage scenario
> > > > where latency sensitive tasks are ever significantly niced in the real
> > > > world?
> > >
> > > It only takes one negatively nice'd proc to affect X adversely.
> >
> > I have an idea. Give me some time to code up my idea. Lack of sleep is
> > making me very unpleasant.
>
> You're excited by RSDL and the positive comments, aren't you? Well, don't
> forget to sleep, sleeping makes ppl smarter you know ;-)
>
>

IIRC, about 2 or three years ago (or maybe on the 2.6.10 timeframe),
there was a patch which managed to pass the interactive from one app
to another when there was a pipe or udp connection between them. This
meant that a marked-as-interactive xterm would, when blocked waiting
for an Xserver response, transfer some of its interactiveness to the
Xserver, and aparently it worked very good for desktop workloads so,
maybe adapting it for this new scheduler would be good.



-- 
Greetz, Antonio Vargas aka winden of network

http://network.amigascne.org/
windNOenSPAMntw@gmail.com
thesameasabove@amigascne.org

Every day, every year
you have to work
you have to study
you have to scene.
