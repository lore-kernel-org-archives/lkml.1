Return-Path: <linux-kernel-owner+w=401wt.eu-S1757966AbXFUUIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966AbXFUUIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 16:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754958AbXFUUIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 16:08:05 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43708 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753194AbXFUUIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 16:08:02 -0400
Date: Thu, 21 Jun 2007 22:07:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: Crispin Cowan <crispin@novell.com>, Greg KH <greg@kroah.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070621200740.GG18990@elf.ucw.cz>
References: <20070609001703.GA17644@kroah.com> <466C303E.5010304@novell.com> <20070615165054.GA11345@kroah.com> <20070615200623.GA2616@elf.ucw.cz> <20070615211157.GB7337@kroah.com> <46732124.80509@novell.com> <20070616000251.GG2616@elf.ucw.cz> <20070621160840.GA20105@marowsky-bree.de> <20070621183311.GC18990@elf.ucw.cz> <20070621192407.GF20105@marowsky-bree.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070621192407.GF20105@marowsky-bree.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I believe AA breaks POSIX, already. rename() is not expected to change
> > permissions on target, nor is link link. And yes, both of these make
> > AA insecure.
> 
> AA is supposed to allow valid access patterns, so for non-buggy apps +
> policies, the rename will be fine and does not change the (observed)
> permissions.

That still breaks POSIX, right? Hopefully it will not break any apps,
but...

> > > If that is the only way to implement AA on top of SELinux - and so far,
> > > noone has made a better suggestion - I'm convinced that AA has technical
> > > merit: it does something the on-disk label based approach cannot handle,
> > > and for which there is demand.
> > What demand? SELinux is superior to AA, and there was very little
> > demand for AA. Compare demand for reiser4 or suspend2 with demand for
> > AA.
> 
> SELinux is superior to AA for a certain scenario of use cases; as we can
> see here, it is not superior to AA for _all_ use cases.

The scenario where it does not seem superior is "I have system with AA
here and I'd like to keep using it".

> > > The code has improved, and continues to improve, to meet all the coding
> > > style feedback except the bits which are essential to AA's function
> > Which are exactly the bits Christoph Hellwig and Al Viro
> > vetoed. http://www.uwsg.iu.edu/hypermail/linux/kernel/0706.1/2587.html
> > . I believe it takes more than "2 users want it" to overcome veto of
> > VFS maintainer.
> 
> A veto is not a technical argument. All technical arguments (except for
> "path name is ugly, yuk yuk!") have been addressed, have they not?

There still is "it does not work with long pathnames".

Plus IIRC we have something like "AA has to allocate path-sized
buffers along every syscall".

I guess Al Viro or Christoph Hellwig would be able to detail on
that. I don't think they are vetoing stuff for fun.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
