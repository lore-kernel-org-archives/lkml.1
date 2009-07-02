Return-Path: <linux-kernel-owner+w=401wt.eu-S1755870AbZGBV0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbZGBV0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 17:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754401AbZGBVZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 17:25:58 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52686 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755144AbZGBVZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 17:25:57 -0400
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: tridge@samba.org, Pavel Machek <pavel@ucw.cz>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20090702191232.5c066790@lxorguk.ukuu.org.uk>
References: <19013.8005.541836.436991@samba.org>
	 <20090630063102.GB1351@ucw.cz> <19019.16217.291678.588673@samba.org>
	 <20090701123141.402c17d2@lxorguk.ukuu.org.uk>
	 <19019.25035.244941.352337@samba.org>
	 <20090701143844.07728fdf@lxorguk.ukuu.org.uk>
	 <19019.27736.647500.497114@samba.org>
	 <20090701154151.7f45abad@lxorguk.ukuu.org.uk>
	 <19020.12748.348370.708306@samba.org>
	 <20090702113200.39a15f21@lxorguk.ukuu.org.uk>
	 <1246546567.4055.27.camel@mulgrave.site>
	 <20090702191232.5c066790@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 21:25:56 +0000
Message-Id: <1246569956.4055.91.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-02 at 19:12 +0100, Alan Cox wrote:
> > As a linux maintainer, you know we try very hard to encourage vendors
> > not to carry long lived out of tree patches because of the complexity it
> > causes for everyone.
> 
> For the non kernel cases with patent questions this isn't the pattern you
> see. And for good reasons. A US patent compliant version of mplayer is
> probably a jpeg viewer. It would be very harmful to the rest of the world
> to gut the main package in that case.

I'd agree *if* we were gutting the package ... and for that reason I
believe not accepting the first incarnation of this patch, which
basically lost the ability to create long filenames was correct.

I think the loss of functionality with this patch is pretty minor so it
is worth carrying it in the kernel.  Obviously, this type of thing has
to be decided on a case by case basis, so there's no precedent (at least
as I see it) being set here.

> For the kernel case the reality is this
> 
> If we include no patch the people concerned will remove the code from
> their distributed source tarball
> 
> If we include a config option, the people concerned will *STILL* remove
> the code from their distributed source tarball.
> 
> so the debate about out of tree patches is not as relevant as might at
> first seem obvious. The simple problem is that the GPL says if you give
> me the binaries I can ask for the sources which produced them. If those
> sources contain the source to an algorithm where there are claims of
> possible patent problems then the lawyers will prefer to play as safe as
> possible and pull the sources that concern them before they even permit
> anyone to type "make". A quick look at some packages from big US
> based vendors will show you that is happening all the time to pull out
> stuff as varied as mp3 playing and the openssh decss crypto mode.

So the advice of our lawyers is that in the US infringement only comes
from practising the patent ... i.e. having a working implementation.
Just giving someone source code for a method to practise it isn't
sufficient ... after all, that's really what a patent specification is
supposed to be: source code in english sufficient to reduce the patent
to practice.

> [Other bits cut, conspiracy case point noted and its why you should not
> post to linux-kernel with a fever temperature ;) ]

Gosh, sorry to hear that ... I find hot honey lemon and brandy useful
for this ... in extreme cases, I just skip the honey and lemon.

> > > There is a clear end user expectation that vfat means "microsoft fat with
> > > extended names". By all means add support for "not vfat" but don't call
> > > it "vfat" as that is misleading an interface breakage.
> > 
> > The Microsoft FAT32 standard only says files with long names *may* be
> > visible on 8.3 FAT systems, it doesn't say *shall*.  Therefore, my
> > reading is that this patch is fully compliant with the FAT32 standard,
> > and thus *is* definitely what we call vfat in Linux.  Or are you
> > claiming that we've somehow extended the definition of vfat to mean
> > complies with FAT32 + makes 8.3 names available as well?
> 
> I'm simply of the viewpoint that users expect certain behaviours and
> compatibilities and that therefore it would be best if the new filesystem
> variant had a new name. I'm not saying cp -r fs/foo fs/bar, just a new
> mount name.

It's a plausible argument.  My counter argument is that in the US with
this patch applied and your fs name change, it would cause all vfat
mounts to have to change mount type ... this is really a massive
surprise to all USB key users here and smoothing it over in the distros
would end up being quite a bit of work.  So, I'd favour, on the
principle of least surprise, keeping the mount name vfat for what is a
compliant implementation of the FAT32 filesystem, albeit missing one
small piece of functionality we previously had.

James


