Return-Path: <linux-kernel-owner+w=401wt.eu-S1760853AbYDCRQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760853AbYDCRQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 13:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760706AbYDCRLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 13:11:36 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4929 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759042AbYDCRLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 13:11:33 -0400
Date: Thu, 3 Apr 2008 18:51:19 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Stefan Hellermann <stefan@the2masters.de>, linux-kernel@vger.kernel.org
Subject: Re: make O=dir fails with current git
Message-ID: <20080403165119.GB4507@ucw.cz>
References: <47EE8829.10409@the2masters.de> <20080331180022.GA4833@uranus.ravnborg.org> <47F12CE9.1090202@the2masters.de> <20080331184247.GC4833@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080331184247.GC4833@uranus.ravnborg.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > >> running "make mrproper" (without O=dir) doesn't help.
> > >> I've not changed anything, I only made a "git-pull".
> > >> Now I'm at home, tried "mkdir test; make O=test defconfig all" with current git-head, it
> > >> doesn't work too.
> > > 
> > > I tried to reproduce this here without luck.
> > > The tests performed by kbuild to dertermine if the
> > > source directory is clean are very basic.
> > > If the file .config exist or the directory
> > > include/config exists then the source tree is considered clean.
> > > Otherwise you get the above message.
> > 
> > Hi, damn, it's that easy!
> > It was the .config file, I added (as root) a symlink to dir/.config to let some other
> > application check if some Kernel-options are set, then the permissions of this symlink
> > prevented make mrproper from removing it.
> > 
> > For what purpose is this check?
> The O= build will use the wrong files if the source tree is not clean.
> There are several special cases which goes wrong under the wrong circumstances
> and therefore this consistency check.

Actually, I keep hitting this all the time. I run make in source tree,
and before I realize my mistake, it creates include/config... which I
have to remove manually before I can use make O=...

Could it perhaps remove include/config when .config does not exist?

Or create include/config only after writting .config?

	(answering 1000 questions takes time, its easy to hit ^c
	there....)
						Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
