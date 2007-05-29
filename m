Return-Path: <linux-kernel-owner+w=401wt.eu-S1751916AbXE2Xay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbXE2Xay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 19:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbXE2Xao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 19:30:44 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33542 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750824AbXE2Xan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 19:30:43 -0400
Date: Wed, 30 May 2007 01:30:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: david@lang.hm
Cc: Crispin Cowan <crispin@novell.com>, Cliffe <cliffe@iinet.net.au>,
       casey@schaufler-ca.com, Kyle Moffett <mrmacman_g4@mac.com>,
       linux-security-module <linux-security-module@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
Message-ID: <20070529233041.GC24200@elf.ucw.cz>
References: <653438.15244.qm@web36612.mail.mud.yahoo.com> <465AE46B.4090109@iinet.net.au> <465B57D7.2040101@novell.com> <20070529144518.GD5840@ucw.cz> <Pine.LNX.4.64.0705291622430.31474@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705291622430.31474@asgard.lang.hm>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>>If we want "/etc/shadow" to be the only way to access the shadow file
> >>>we could label the data with "/etc/shadow". Any attempts to access
> >>>this data using a renamed file or link would be denied (attempts to
> >>>link or rename could also be denied).
> >>Eloquently put.
> >>
> >>AppArmor actually does something similar to this, by mediating all of
> >>the ways that you can make an alias to a file. These are:
> >...
> >>    * Hard links: AppArmor explicitly mediates permission to make a hard
> >
> >Unfortunately, aparmor is by design limited to subset of distro
> >(network daemons). Unfortunately, some other programs (passwd, vi)
> >routinely make hardlinks. So AA mediating hardlink is not enough, as
> >vi will happily hardlink /etc/shadow into /etc/.vi-shadow-1234.
> 
> but with the AA design of default deny this isn't a big problem unless you 
> specificly allow some network daemon to access /etc/.vi-shadow-1234

...or unless vi decides to hardlink into /tmp or something.

> no, this won't help you much against local users, but there are a _lot_ of 
> boxes out there with few, if any, local users who don't also have the root 
> password. AA helps the admin be safer when configuring netwrok daemons.

Hmm, I guess I'd love "it is useless on multiuser boxes" to become
standard part of AA advertising.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
