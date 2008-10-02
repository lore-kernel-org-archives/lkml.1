Return-Path: <linux-kernel-owner+w=401wt.eu-S1755315AbYJBQce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbYJBQce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 12:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753911AbYJBQc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 12:32:26 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:54265 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844AbYJBQcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 12:32:25 -0400
Date: Thu, 2 Oct 2008 18:32:05 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: "Leisner, Martin" <Martin.Leisner@xerox.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, marty <martyleisner@yahoo.com>,
       linux-kernel@vger.kernel.org
Subject: Re: disk IO directly from PCI memory to block device sectors
Message-ID: <20081002163205.GJ19428@kernel.dk>
References: <247018.46515.qm@web50603.mail.re2.yahoo.com> <20080926094653.1e0a9260@lxorguk.ukuu.org.uk> <20080926091135.GV2677@kernel.dk> <556445368AFA1C438794ABDA8901891C0999203A@USA0300MS03.na.xerox.net> <20080929130222.GX2677@kernel.dk> <20081001190546.GQ19428@kernel.dk> <c384c5ea0810020915r3023bapecc99b7fcd67b81c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c384c5ea0810020915r3023bapecc99b7fcd67b81c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02 2008, Leon Woestenberg wrote:
> Hello Jens,
> 
> On Wed, Oct 1, 2008 at 9:05 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Mon, Sep 29 2008, Jens Axboe wrote:
> >> On Fri, Sep 26 2008, Leisner, Martin wrote:
> >> IMHO, this interface totally rocks. It's really async like splice was
> >
> > Alright, so this one actually works :-)
> > Apart from fixing the bugs in it, it's also more clever in using the bio
> > for the write part. It'll reuse the same bio in the splice actor until
> > it's full, only then submitting it and allocating a new one. The read
> > part works the same way.
> >
> I have been following this thread trying to grasp a very nifty use
> case (high speed acquisition and storage of data) of splice.
> 
> I think it would make a perfect example of splice functionality.
> 
> What would the user space part look like to exercise this interface?

Download:

http://brick.kernel.dk/snaps/splice-git-latest.tar.gz

which has lots of little examples for splice. You would want to do
something ala

# splice-in /dev/my-pci-device | splice-out /dev/sda

in one app of course, but take a look at the examples and get a feel for
the interface...

BTW, in my splice branch I have this queued as well. Not going anywhere
for now, but should get updated and tested every now and then.

http://git.kernel.dk/?p=linux-2.6-block.git;a=shortlog;h=refs/heads/splice

-- 
Jens Axboe

