Return-Path: <linux-kernel-owner+w=401wt.eu-S1754481AbXFDLH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbXFDLH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 07:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753339AbXFDLHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 07:07:49 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34754 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753267AbXFDLHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 07:07:48 -0400
Date: Mon, 4 Jun 2007 13:07:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: david@lang.hm
Cc: Valdis.Kletnieks@vt.edu,
       David Wagner <daw-usenet@taverner.cs.berkeley.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
Message-ID: <20070604110743.GN4363@elf.ucw.cz>
References: <653438.15244.qm@web36612.mail.mud.yahoo.com> <20070529144518.GD5840@ucw.cz> <Pine.LNX.4.64.0705291622430.31474@asgard.lang.hm> <20070529233041.GC24200@elf.ucw.cz> <f3il25$pcp$1@taverner.cs.berkeley.edu> <20070524144726.GB3920@ucw.cz> <12508.1180719875@turing-police.cc.vt.edu> <Pine.LNX.4.64.0706011048550.25896@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706011048550.25896@asgard.lang.hm>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2007-06-01 11:00:50, david@lang.hm wrote:
> On Fri, 1 Jun 2007, Valdis.Kletnieks@vt.edu wrote:
> 
> >On Thu, 24 May 2007 14:47:27 -0000, Pavel Machek said:
> >>Yes, if there's significantly more remote bad guys than local bad
> >>guys, and if remote bad guys can't just get some local user first, AA
> >>still has some value.
> >
> >Experience over on the Windows side of the fence indicates that "remote bad
> >guys get some local user first" is a *MAJOR* part of the current real-world
> >threat model - the vast majority of successful attacks on end-user boxes 
> >these
> >days start off with either "Get user to (click on link|open attachment)" or
> >"Subvert the path to a website (either by hacking the real site or 
> >hijacking
> >the DNS) and deliver a drive-by fruiting when the user visits the page".
> 
> and if your local non-root user can create a hard link to /etc/shadow and 
> access it they own your box anyway (they can just set the root password to 
> anything they want). 

I think you need to look how unix security works:

pavel@amd:/tmp$ ln /etc/shadow .
pavel@amd:/tmp$ cat shadow
cat: shadow: Permission denied
pavel@amd:/tmp$

Yes, regular users are permitted to hardlink shadow, no, it is not a
security hole, yes, it is a problem for AA.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
