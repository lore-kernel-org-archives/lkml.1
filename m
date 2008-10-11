Return-Path: <linux-kernel-owner+w=401wt.eu-S1756452AbYJKPGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452AbYJKPGT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 11:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbYJKPGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 11:06:10 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:41541 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbYJKPGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 11:06:09 -0400
Date: Sat, 11 Oct 2008 17:05:32 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: petkovbb@gmail.com, Robert Hancock <hancockr@shaw.ca>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] ide: locking improvements
Message-ID: <20081011150532.GU19428@kernel.dk>
References: <fa.Ke90oacfRjgiI4x5LejzjssRBEg@ifi.uio.no> <20081011120137.GA26835@gollum.tnic> <20081011135300.GP19428@kernel.dk> <200810111645.27847.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810111645.27847.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11 2008, Bartlomiej Zolnierkiewicz wrote:
> On Saturday 11 October 2008, Jens Axboe wrote:
> > On Sat, Oct 11 2008, Borislav Petkov wrote:
> > > > >From my perspective the main gain of these patches is the increased
> > > > maintainability and sanity of the code, scalability improvements are
> > > > just an added bonus.
> > > 
> > > and better code/improved scalability is a bad thing because... ?!
> > 
> > It's a bad thing because nobody on earth cares about IDE scalability,
> 
> JFYI: just yesterday I got mail proving otherwise. ;)

Well, there are lots of crazy people in the world, a request from
someone doesn't necessarily make it a good idea :-)

> > from a performance POV a modern SATA controller is just better on
> > several levels. I don't think anybody cares about IDE scaling on 8-16
> > cores or more, simply because NOBODY is using IDE on such systems.
> > 
> > As such, trying to improve locking is a pointless exercise. And that is
> > a bad thing, because code change invariably brings in code bugs. Then
> > see previous mail on lack of coverage testing, and it can naturally be
> > harmful.
> 
> Your concerns were already addressed in my reply but I worry that having
> a discussion based on technical arguments is not your goal.

You make it sound like I have an alterior motive, which I definitely do
not. I just wondered what all the IDE churn was supposed to be good
for...

> Just to repeat: these patches are not hardware specific and obviously
> they are not going to be merged today, tomorrow or in a week (they are
> 2.6.29 material after months of time in pata tree / linux-next).

It's less about this specific patchset than in general. The specific one
looked fine by itself, it's just the path to to 'IDE lock scaling' that
is a bit crazy to me. Moving IDE to the softirq completion like SCSI
would be a better start, imho. IDE still does most of the processing
under its ide_lock, which isn't even necessary. Making the locking more
finely grained is what I think is pretty crazy.

> > > > > rather like putting makeup on a corpse to me..
> > > 
> > > so _NOT_ true.
> > 
> > Depends on what you think is the corpse. Since IDE is essentially dead
> > and frozen, it IS a corpse and the phrase is then very appropriate. This
> > is not a personal jab at the IDE guys and does not reflect on the
> > (mostly) good work they do, just a reflection on the state of IDE in
> > general.
> 
> Interesting statement given that i.e. diffstat-wise pata tree has more
> than twice as much stuff queued up for 2.6.28 than "some other" trees
> (and we have history of being a _very_ conservative w.r.t. to needlessly
> moving code around in drivers/ide/).
> 
> Please stop being silly and pushing your view/idea on what other people
> should be doing (not to mention ignoring real facts).

Please start by actually _reading_ what I write. Your reply is based on
the code base, my statement pertains to IDE on the hardware side
(devices, controllers, etc). On the scalability front, what new hardware
do you envision shipping with IDE controllers that are actually used for
pushing large amounts of data? People would have to be borderline insane
to make such new hw today.

I'm not pushing my views on anyone, but I am free to share what I
actually think. I actually care about old code stability, hence my
concern with the amount of IDE changes.

-- 
Jens Axboe

