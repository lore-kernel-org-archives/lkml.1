Return-Path: <linux-kernel-owner+w=401wt.eu-S1755280AbZGBO4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbZGBO4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 10:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbZGBO4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 10:56:22 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45501 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753855AbZGBO4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 10:56:11 -0400
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: tridge@samba.org, Pavel Machek <pavel@ucw.cz>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20090702113200.39a15f21@lxorguk.ukuu.org.uk>
References: <19013.8005.541836.436991@samba.org>
	 <20090630063102.GB1351@ucw.cz> <19019.16217.291678.588673@samba.org>
	 <20090701123141.402c17d2@lxorguk.ukuu.org.uk>
	 <19019.25035.244941.352337@samba.org>
	 <20090701143844.07728fdf@lxorguk.ukuu.org.uk>
	 <19019.27736.647500.497114@samba.org>
	 <20090701154151.7f45abad@lxorguk.ukuu.org.uk>
	 <19020.12748.348370.708306@samba.org>
	 <20090702113200.39a15f21@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 14:56:07 +0000
Message-Id: <1246546567.4055.27.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-02 at 11:32 +0100, Alan Cox wrote:
> > I think you'll find that most distro makers and most vendors of Linux
> > based devices will want to have this patch applied. So if we took the
> 
> Good for them
> 
> > approach you suggest, then the testing done via kernel.org trees will
> > not match what the vast majority of Linux users will actually be
> > running. That would seem to be counter to good QA practices.
> 
> The vendor trees all contain patches and have done for years, often lots
> of them. They will apply the patch if you put VFAT_DUALNAMES into the
> kernel as well so your argument is totally bogus. It always was totally
> bogus, it always will be. Vendors do not use the base kernel as is in
> normal product. They ship

As a linux maintainer, you know we try very hard to encourage vendors
not to carry long lived out of tree patches because of the complexity it
causes for everyone.

> 	Base kernel
> 	+ Patches for packaging systems
> 	+ .1/.2/.3 bits
> 	+ Cherry pick of stuff that deals with bugs they think have to be
> 	  stomped by some means
> 	+ drivers they add which are not yet fit for kernel
> 	+ exciting stuff they think is cool and makes their distro
> 	  special (eg KMS patches)

Right but all of the above are short lived except the packaging patches
(which are distro kernel specific), meaning they eventually go upstream.
You're proposing a permanent out of tree patch, which is counter to
this.

> Its starting to sound like the Foundation and someone have signed some
> kind of settlement to get this change into the Linux kernel regardless of
> the technical issues, practicality or community and this is all for show
> anyway.

This is getting a bit far into conspiracy theories even for you, but if
I must I can categorically deny this.  The involvement of the Linux
foundation in this area is threefold:

     1. Pulling together OIN, OSAPA and a few other patent projects into
        a workable patent shield around Linux.
     2. Specifically for TomTom, assisting with their patent defence by
        explaining open source to their lawyers and also putting them in
        touch with OIN.
     3. For this patch, since there are legal issues which could harm
        the defence of any company to be discussed openly, the LF is
        paying the retainer for John Lanza to be available to any member
        of the community on a one on one basis, so that the discussions
        they engage in would be protected by client privilege (i.e. not
        subject to discovery).

In my book that amounts to trying to mitigate some of the impacts of the
US patent system on open source and linux rather than conspiracy.  You
could also see the "undisclosed settlement" in the TomTom case, with
virtually no repercussions for Tom Tom shipping Linux, as a reasonable
success of the above strategy.

> > If the patch had significant negative consequences for normal use then
> 
> You said yourself it can crash XP.
> 
> > If we get some real examples of devices that are badly affected
> 
> XP crashing by suprise if you are really really unlucky strikes me as a
> good example and one you provided.

OK, so this is a legitimate technical concern ... somewhat mitigated by
the fact that a lot of other FAT32 implementations also crash XP.

> You've also ignored entirely the fact that this isn't a VFAT file system
> so irrespective of whether this goes in it should not be used for mount
> -o vfat.
> 
> There is a clear end user expectation that vfat means "microsoft fat with
> extended names". By all means add support for "not vfat" but don't call
> it "vfat" as that is misleading an interface breakage.

The Microsoft FAT32 standard only says files with long names *may* be
visible on 8.3 FAT systems, it doesn't say *shall*.  Therefore, my
reading is that this patch is fully compliant with the FAT32 standard,
and thus *is* definitely what we call vfat in Linux.  Or are you
claiming that we've somehow extended the definition of vfat to mean
complies with FAT32 + makes 8.3 names available as well?

James


