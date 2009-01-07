Return-Path: <linux-kernel-owner+w=401wt.eu-S1759757AbZAGPes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759757AbZAGPes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 10:34:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbZAGPej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 10:34:39 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48332 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752109AbZAGPei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 10:34:38 -0500
Subject: Re: [PATCH] block: export SSD/non-rotational queue flag through
	sysfs
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Jens Axboe <jens.axboe@oracle.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <4964866D.8010503@msgid.tls.msk.ru>
References: <200901051952.58029.bzolnier@gmail.com>
	 <20090105185428.GS32491@kernel.dk>
	 <ac3eb2510901051347r6593d0fmd64702b1689716c1@mail.gmail.com>
	 <20090106073515.GY32491@kernel.dk>  <4964866D.8010503@msgid.tls.msk.ru>
Content-Type: text/plain
Date: Wed, 07 Jan 2009 09:34:33 -0600
Message-Id: <1231342473.3282.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-07 at 13:39 +0300, Michael Tokarev wrote:
> Jens Axboe wrote:
> > On Mon, Jan 05 2009, Kay Sievers wrote:
> >> On Mon, Jan 5, 2009 at 19:54, Jens Axboe <jens.axboe@oracle.com> wrote:
> >>> On Mon, Jan 05 2009, Bartlomiej Zolnierkiewicz wrote:
> >>>> +static struct queue_sysfs_entry queue_nonrot_entry = {
> >>>> +     .attr = {.name = "nonrot", .mode = S_IRUGO | S_IWUSR },
> >>>> +     .show = queue_nonrot_show,
> >>>> +     .store = queue_nonrot_store,
> >>>> +};
> >>>> +
> >>> Lets please use a better name for export reasons, non-rotational is a
> >>> lot better. Nobody will know what nonrot means :-)
> >> What's that negation good for? Can't we just have "rotational", like
> >> we have "removable" and not "non-removable"? :)
> > 
> > Non-rotational is the term typically used, since rotational is the norm
> > (still). So I think the negation actually makes sense in this case :-)
> 
> You used the word "still" yourself.  I mean, in 5 years SSD will be more
> common than rotational media, and "the norm" will be !rotational..
> So let's name them correctly and uniformly from the beginning.. ;)

I'm afraid that's pretty much marketing coolaid.  Rotational storage
will dominate for the forseeable future: just do a simple back of the
envelope calculation:

      * Total shipped spinning storage in 2008: 128EB (Gartner figures)
      * If all the chip FABs in all the world were turned solely to
        flash production, they'd be able to ship about 16EB per year (or
        about 13%  of the total 2008 consumption [estimate from Steve
        Hetzler, IBM]), assuming any given FAB can produce about 0.5EB
        per year).
      * Then factor in that storage requirements are growing
        exponentially (the 2009 estimated requirement is 400EB).
      * Given that it costs ~$3-7bn for one fab plant and that we're in
        an economic depression, no-one is making the necessary trillion
        dollar capital investment to even make Flash be a significant
        fraction of the current storage market ... it's not even clear
        that it will be able to break the 1% barrier, let alone the 10%
        one.

That's not to say flash isn't important, it is; it's just to remind
everyone that storage subsystems will be focused on rotating media.  Any
flash features we add have to make sure they don't impact our rotating
performance.

Sorry, now we can go back to regularly scheduled programming.  This
isn't the first "everything will be flash and we should be planning for
it" type statement, but I thought a little reality injection would be
appropriate at this juncture.

James


