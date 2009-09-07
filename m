Return-Path: <linux-kernel-owner+w=401wt.eu-S1752479AbZIGMwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbZIGMwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 08:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbZIGMwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 08:52:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47795 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbZIGMwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 08:52:46 -0400
Date: Mon, 7 Sep 2009 14:51:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>, Christoph Hellwig <hch@lst.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mmc@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: Regression in suspend to ram in 2.6.31-rc kernels
Message-ID: <20090907125130.GA1595@ucw.cz>
References: <c4e36d110908310451t7c238e09u5af112fa3321cc23@mail.gmail.com> <200908312119.12121.rjw@sisk.pl> <c4e36d110909010234i5f1b9357l805132137725a4f8@mail.gmail.com> <c4e36d110909031529q77b53122kdb85785ba293c478@mail.gmail.com> <20090903232317.GA6760@lst.de> <87ljkvmt71.fsf@devron.myhome.or.jp> <c4e36d110909040213t4d4258b4w3e2d4725e0b2a161@mail.gmail.com> <87iqfx5mss.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87iqfx5mss.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>> Note that when you rever this patch on a current kernel you do actually
> >>> get different behvaviour than when going back to before this commit.
> >>>
> >>> In 2.6.30 we called ->write_super in the various sync functions and
> >>> then ->sync_fs, in 2.6.31-rc8 you would not call any syncing at all
> >>> anymore. ?I think this patch might just be a symptom for a situation
> >>> where the suspend code causes a sync and the mmc driver can't handle
> >>> it anymore.
> >
> > So - here is the console trace from suspend when I've added
> > dump_stack() to the fat_sync_fs()   (and also added debug prints
> > around each call in this function -so its obvious the function is
> > actually left - but then it freezes later somewhere.)
> >
> > It's interesting that 3 calls to sync happens.
> 
> It seems
> 
>     1) sync() (probabry "sync" command)
>     2) sync as part of suspend sequence
>     3) sync_filesystem() by mmc remove event
> 
> I guess the root-cause of the problem would be 3). However, it would not
> be easy to fix, at least, we would need to think about what we want to
> do for it. So, to workaround it for now, I've made this patch.

MMC driver trying to synchronize filesystems looks like ugly layering
violation to me. Why are we doing that?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
