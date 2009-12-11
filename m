Return-Path: <linux-kernel-owner+w=401wt.eu-S1758741AbZLKPaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741AbZLKPaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 10:30:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758635AbZLKP3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 10:29:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758850AbZLKP3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 10:29:50 -0500
Date: Fri, 11 Dec 2009 07:28:42 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jeff Garzik <jeff@garzik.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Stephane Marchesin <stephane.marchesin@gmail.com>,
       Maarten Maathuis <madman2003@gmail.com>,
       Xavier Bestel <xavier.bestel@free.fr>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm
In-Reply-To: <4B221EDA.5020902@garzik.org>
Message-ID: <alpine.LFD.2.00.0912110710510.3560@localhost.localdomain>
References: <alpine.DEB.2.00.0912100603070.24701@skynet.skynet.ie> <alpine.LFD.2.00.0912100716470.3560@localhost.localdomain> <1260459601.18520.26.camel@skunk> <alpine.LFD.2.00.0912100823220.3560@localhost.localdomain> <6d4bc9fc0912100940l1d2954d0k187ae54bf44a23f5@mail.gmail.com>
 <alpine.LFD.2.00.0912101035140.3560@localhost.localdomain> <6a89f9d50912101153l2b58b07fudf6965b2f5172f7f@mail.gmail.com> <alpine.LFD.2.00.0912101531180.3560@localhost.localdomain> <20091210235835.20e2269d@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0912101601100.3560@localhost.localdomain>
 <20091211091843.0a543136@lxorguk.ukuu.org.uk> <4B221EDA.5020902@garzik.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 11 Dec 2009, Jeff Garzik wrote:
> 
> F11 uses nouveau here.  It is actually a pain to get 'nv' going as an
> alternate -- bugs have been filed.  Makes kernel dev more difficult for me.  I
> was actually told, by Fedora people, that I should be hacking on the Fedora
> (rpm-based) kernel, rather than a 100% upstream kernel like I have been
> hacking/booting for the past decade, as a result of this setup (needing
> nouveau kernel support, thus needing Fedora rather than upstream kernel).

Btw, for all my ranting (and maybe Alan is right, and I'm ranting at the 
wrong people - it's just that the actual driver authors aren't the ones 
that violated any rules), I do have to give kudos for the fact that the 
F12 situation seems to be much better.

These days, what you can do is basically do all development (assuming it's 
not nouveau development) in the upstream kernel, and then you just have a 
separate 'nouveau' git tree (or branch) that you pull in the nouvea stuff 
into.

That tree/branch will be a mess of random merges-of-the-day, but you'll 
never push it out to anybody anyway, so nobody cares. And building that 
messy merge tree will get you a working setup without any extra steps - a 
simple "make modules_install ; make install" will JustWork(tm).

So it's much more straightforward than it used to be (you had that 
separate tree that you could build modules in), you can basically build 
things exactly the same way you are supposed to do things _anyway_ if you 
have experimental branches etc and want to build in a temporary merged 
tree (even if you're not actually ready to merge it all and still want to 
keep the branches separate).

Of course, it's a good thing that it's easier in F12, because in F11 if 
you forgot to build the nouveau stuff, it would just fall back on the VESA 
FB setup - you had a working system, it was just very slow X. You could 
then build the nouveau modules you forgot about, and re-start X.

That "oops, I forgot" case seems to no longer work at all in F12 - if I 
build without Nouveau on my nvidia machine, the kernel will boot, but I 
will have neither working X _nor_ a working text login. So there's no way 
to even build the modules and fix it up - you have just to re-boot back 
into an old kernel. Very annoying for bisection.

			Linus
