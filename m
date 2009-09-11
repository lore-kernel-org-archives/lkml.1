Return-Path: <linux-kernel-owner+w=401wt.eu-S1757113AbZIKWWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113AbZIKWWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 18:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756982AbZIKWWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 18:22:17 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39199 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbZIKWWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 18:22:16 -0400
Date: Sat, 12 Sep 2009 00:21:54 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Christoph Hellwig <hch@lst.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mmc@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: Regression in suspend to ram in 2.6.31-rc kernels
Message-ID: <20090911222154.GB11441@elf.ucw.cz>
References: <c4e36d110908310451t7c238e09u5af112fa3321cc23@mail.gmail.com> <20090910192354.GD23356@elf.ucw.cz> <87bplim1ce.fsf@devron.myhome.or.jp> <200909120004.02146.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909120004.02146.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-09-12 00:04:02, Rafael J. Wysocki wrote:
> On Friday 11 September 2009, OGAWA Hirofumi wrote:
> > Pavel Machek <pavel@ucw.cz> writes:
> > 
> > > On Wed 2009-09-09 22:21:56, OGAWA Hirofumi wrote:
> > >> Pavel Machek <pavel@ucw.cz> writes:
> > >> 
> > >> >> It seems
> > >> >> 
> > >> >>     1) sync() (probabry "sync" command)
> > >> >>     2) sync as part of suspend sequence
> > >> >>     3) sync_filesystem() by mmc remove event
> > >> >> 
> > >> >> I guess the root-cause of the problem would be 3). However, it would not
> > >> >> be easy to fix, at least, we would need to think about what we want to
> > >> >> do for it. So, to workaround it for now, I've made this patch.
> > >> >
> > >> > MMC driver trying to synchronize filesystems looks like ugly layering
> > >> > violation to me. Why are we doing that?
> > >> 
> > >> There is no _layering violation_ here. IIRC, mmc just tells card removed
> > >> event to another layer (on some points of view, to tell event can be
> > >> wrong though). The partition (block) layer does it by event.
> > >
> > > So what is the problem?  Emulating sync when card is already removed
> > > seems little ... interesting?
> > 
> > Um..., sorry, I'm not sure what are you talking about. Of course, the
> > problem of this is that system freeze on suspend.
> > 
> > Or are you asking my guess of the cause, or something?  If so, although
> > I'm not reading all emails on this thread, from Zdenek's backtrace, the
> > sequence would be
> > 
> >     1) suspend mmc
> >     2) mmc generates card removed event
> 
> Which shouldn't happen.

Are you sure? IIRC it depends on  CONFIG_MMC_UNSAFE_RESUME.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
