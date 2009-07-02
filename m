Return-Path: <linux-kernel-owner+w=401wt.eu-S1753943AbZGBMix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbZGBMix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 08:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbZGBMin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 08:38:43 -0400
Received: from mail.samba.org ([66.70.73.150]:49345 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbZGBMim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 08:38:42 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19020.43585.375900.217202@samba.org>
Date: Thu, 2 Jul 2009 22:38:25 +1000
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       john.lanza@linux.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
In-Reply-To: <20090702113200.39a15f21@lxorguk.ukuu.org.uk>
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
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

 > The vendor trees all contain patches and have done for years, often lots
 > of them. They will apply the patch if you put VFAT_DUALNAMES into the
 > kernel as well so your argument is totally bogus. It always was totally
 > bogus, it always will be.

well, I certainly don't have your experience with kernel development,
but it seems fairly basic to me that if a patch is likely to be in use
by the majority of Linux users (via distros/vendors) that having it in
the upstream kernel makes sense. 

If I'm wrong and a large proportion of distros/vendors won't want this
patch then of course the argument falls down, and in that case it
would seem perfectly reasonable for the upstream kernel not to have
it, or for it to be inactive by default.

Meanwhile it has gone into fatfs-2.6, and linux-next where I hope it
will get some testing. Whether it then goes into Linus's tree for
2.6.32 is a decision for Hirofumi (and presumably Linus if he decides
to weigh in on this). Similarly what the default should be is their
decision. I'm happy that it is getting some testing now, and I hope
that if that testing doesn't show any issues that it will be accepted
for 2.6.32.

 > Its starting to sound like the Foundation and someone have signed some
 > kind of settlement to get this change into the Linux kernel regardless of
 > the technical issues, practicality or community and this is all for show
 > anyway.

err, no. The idea for this patch came when I was reading the first lwn
article on the TomTom suit, and because I happen to have a TomTom at
home and like it. I then started investigating and found some ways to
avoid the patent. I do patent avoidance work quite frequently,
although usually for Samba and in that case I just put the patches
into Samba along with the rest of my code.

There is no "settlement" here (who exactly are you saying is settling
with whom??). There is just a patent avoidance patch that I think is a
very good idea, and that I have gone to the effort of getting very
carefully checked by the appropriate experts. I was helped in this by
some extremely good people (such as Paul McKenney, who has a lot of
experience in this area), and I think the result is a good one.

This discussion is not for show. If Hirofumi/Linus or whoever else is
responsible reject the patch then we don't have any secret backdoor to
get it in. All we can do is present the patch and hope to persuade the
kernel community that it is a good idea.

 > > If the patch had significant negative consequences for normal use then
 > 
 > You said yourself it can crash XP.

well, the WindowsXP fastfat driver isn't exactly known as being
stable! Do a search for fastfat bluescreen and you'll find a huge
number of hits on people complaining about it bluescreening when it
opens FAT filesystems created by all sorts of systems (eg. iPods).

 > You've also ignored entirely the fact that this isn't a VFAT file system
 > so irrespective of whether this goes in it should not be used for mount
 > -o vfat.

Other OSes (eg. Windows) don't tend to distinguish between FAT and
VFAT. It is just a FAT filesystem with a varying range of features. On
Linux we've chosen one particular set of features and labelled that
VFAT, then we've chosen a different set of features and labelled it
'MSDOS'. Within what we have labelled as VFAT we have some existing
runtime options that select different varients. I would have liked to
do the 'dualnames' patch as a runtime option, but that doesn't satisfy
the legal requirements.

So I think you're coming at this very much from a Linux centric point
of view (not surprising!), and even there I very much doubt that many
end users think about the intricacies of what FAT filesystem options
they want. Most systems just auto-mount removable media these days
with whatever options the distro vendors choose (or via HAL rules).

Thus I don't think the "end user expectation" is a strong argument for
making this an entirely new filesystem.

It really is up to Hirofumi-san though. If he asks me to redo the
patch so that it creates a new FAT filesystem varient then I'd be more
than happy to do that. I personally think it will create more
maintainence overhead than it is worth, but as the FAT filesystem
maintainer it is certainly his choice.

Cheers, Tridge
