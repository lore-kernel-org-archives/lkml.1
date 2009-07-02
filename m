Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbZGBSLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbZGBSLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 14:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbZGBSLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 14:11:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44415 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752206AbZGBSLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 14:11:21 -0400
Date: Thu, 2 Jul 2009 19:12:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: tridge@samba.org, Pavel Machek <pavel@ucw.cz>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Message-ID: <20090702191232.5c066790@lxorguk.ukuu.org.uk>
In-Reply-To: <1246546567.4055.27.camel@mulgrave.site>
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
	<19019.16217.291678.588673@samba.org>
	<20090701123141.402c17d2@lxorguk.ukuu.org.uk>
	<19019.25035.244941.352337@samba.org>
	<20090701143844.07728fdf@lxorguk.ukuu.org.uk>
	<19019.27736.647500.497114@samba.org>
	<20090701154151.7f45abad@lxorguk.ukuu.org.uk>
	<19020.12748.348370.708306@samba.org>
	<20090702113200.39a15f21@lxorguk.ukuu.org.uk>
	<1246546567.4055.27.camel@mulgrave.site>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As a linux maintainer, you know we try very hard to encourage vendors
> not to carry long lived out of tree patches because of the complexity it
> causes for everyone.

For the non kernel cases with patent questions this isn't the pattern you
see. And for good reasons. A US patent compliant version of mplayer is
probably a jpeg viewer. It would be very harmful to the rest of the world
to gut the main package in that case.

For the kernel case the reality is this

If we include no patch the people concerned will remove the code from
their distributed source tarball

If we include a config option, the people concerned will *STILL* remove
the code from their distributed source tarball.

so the debate about out of tree patches is not as relevant as might at
first seem obvious. The simple problem is that the GPL says if you give
me the binaries I can ask for the sources which produced them. If those
sources contain the source to an algorithm where there are claims of
possible patent problems then the lawyers will prefer to play as safe as
possible and pull the sources that concern them before they even permit
anyone to type "make". A quick look at some packages from big US
based vendors will show you that is happening all the time to pull out
stuff as varied as mp3 playing and the openssh decss crypto mode.

[Other bits cut, conspiracy case point noted and its why you should not
post to linux-kernel with a fever temperature ;) ]

> > There is a clear end user expectation that vfat means "microsoft fat with
> > extended names". By all means add support for "not vfat" but don't call
> > it "vfat" as that is misleading an interface breakage.
> 
> The Microsoft FAT32 standard only says files with long names *may* be
> visible on 8.3 FAT systems, it doesn't say *shall*.  Therefore, my
> reading is that this patch is fully compliant with the FAT32 standard,
> and thus *is* definitely what we call vfat in Linux.  Or are you
> claiming that we've somehow extended the definition of vfat to mean
> complies with FAT32 + makes 8.3 names available as well?

I'm simply of the viewpoint that users expect certain behaviours and
compatibilities and that therefore it would be best if the new filesystem
variant had a new name. I'm not saying cp -r fs/foo fs/bar, just a new
mount name.

