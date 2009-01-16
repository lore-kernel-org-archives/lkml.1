Return-Path: <linux-kernel-owner+w=401wt.eu-S1758122AbZAPGuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122AbZAPGuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 01:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbZAPGuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 01:50:22 -0500
Received: from brick.kernel.dk ([93.163.65.50]:22189 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550AbZAPGuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 01:50:21 -0500
Date: Fri, 16 Jan 2009 07:48:58 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Dongjun Shin <djshin90@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Hugh Dickins <hugh@veritas.com>, Grant Grundler <grundler@google.com>,
       Greg Freemyer <greg.freemyer@gmail.com>, Tejun Heo <htejun@gmail.com>,
       Michael Tokarev <mjt@tls.msk.ru>, Kay Sievers <kay.sievers@vrfy.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] block: export SSD/non-rotational queue flag through sysfs
Message-ID: <20090116064857.GT30821@kernel.dk>
References: <496ECBA0.60209@gmail.com> <87f94c370901150707h10506e99reaa40c23e32ab18c@mail.gmail.com> <1232035561.5966.48.camel@localhost.localdomain> <da824cf30901151055o2385ef74x918e8390e576d807@mail.gmail.com> <1232046039.5966.54.camel@localhost.localdomain> <da824cf30901151445q6b54c0b1nbf24f03849e1a5b3@mail.gmail.com> <1232061429.5966.87.camel@localhost.localdomain> <Pine.LNX.4.64.0901152341500.15035@blonde.anvils> <1232066174.5966.92.camel@localhost.localdomain> <7fe698080901151952u4c6157d3tca8d745b69cacc1e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fe698080901151952u4c6157d3tca8d745b69cacc1e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16 2009, Dongjun Shin wrote:
> On Fri, Jan 16, 2009 at 9:36 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> >
> > On Thu, 2009-01-15 at 23:50 +0000, Hugh Dickins wrote:
> > > On Thu, 15 Jan 2009, James Bottomley wrote:
> > > >
> > > > OK, so they could be calculated on the fly in the elevators, I suppose.
> > > > But what would the value be?  Right now we use the nonrotational flag to
> > > > basically not bother with plugging (no point if no seek penalty) on
> > > > certain events where we'd previously have waited for other I/O to join.
> > > > But that's really a seek penalty parameter rather than the idea of read
> > > > or write costing (although the elevators usually track these dynamically
> > > > anyway ... as part of the latency calculations but not explicitly).
> > >
> > > ... not bother with plugging (no point if no seek penalty) ...
> > >
> > > I thought there was considerable advantage to plugging writes
> > > (in case they turn out to be adjacent) on current and older
> > > generations of non-rotational storage?
> >
> > Heh, you get as many answers to that one as their are SSD manufacturers.
> > However, the consensus seems to be that all MLC and SLC flash has a RAID
> > like architecture internally, thus it can actually be *faster* if you
> > send multiple commands (each area of the RAID processes independently).
> > Of course, you have to be *able* to send multiple commands, so the
> > device must implement TCQ/NCQ, but if it does, it's actually beneficial
> > *not* to wait even if the requests are adjacent.
> >
> > However, the reason the nonrotational flag is set from user space is
> > precisely so if we do find an SSD that has this property, we can just
> > not set the nonrotational queue flag.
> >
> 
> Not all non-rotational SSDs are created equal (as Intel said).
> 
> Some SSD performs better as the I/O queue length increase, while others not.
> For SSD with scalable queueing performance, it might be better to allow
> multiple discrete I/Os.
> 
> I'm not sure if "non-rotational" is well suited for tuning the
> behavior of elevator merging.

It's not tuning merging, that's a seperate tuning knob if someone
wishes to turn that off.

-- 
Jens Axboe

