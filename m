Return-Path: <linux-kernel-owner+w=401wt.eu-S1761590AbXJMIRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761590AbXJMIRB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 04:17:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759977AbXJMIQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 04:16:31 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:56158 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758095AbXJMIQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 04:16:27 -0400
Date: Sat, 13 Oct 2007 10:17:59 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Giacomo Catenazzi <cate@debian.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23.git build error
Message-ID: <20071013081759.GB28168@uranus.ravnborg.org>
References: <1192164538.10413.3.camel@Homer.simpson.net> <20071012213114.GA24016@uranus.ravnborg.org> <1192246457.7395.19.camel@Homer.simpson.net> <47105A39.9070406@debian.org> <20071013071626.GA28168@uranus.ravnborg.org> <1192260909.7369.20.camel@Homer.simpson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192260909.7369.20.camel@Homer.simpson.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2007 at 09:35:09AM +0200, Mike Galbraith wrote:
> On Sat, 2007-10-13 at 09:16 +0200, Sam Ravnborg wrote:
> 
> > Pulled 2.6.23 tree and did a build
> > Added latest -linus on top of it.
> > Did a new build (x86_64).
> > 
> > 
> > As expected it failed due to wrong asm symlink but nothing
> > like the error Mike posted.
> > So I'm a bit puzzeled here.
> > 
> > I anyone can explain how to reproduce it I will chase it
> > but otherwise it will be left as a "consequence of
> > the x86 merge".
> 
> What I did was to pull, then diff against my working tree (/me=SCM
> weenie;) for review as usual, and then apply that diff to working tree
> and make oldconfig as usual.  That left me with the same failure this
> morning, despite the file being verified present in the git tree.  I
> then used git-archive --format=tar | (cd work_tree;tar -xvf -).  That
> spewed chunks when I tried to build it even though diff said the trees
> were identical.  After make mrproper and restoring my saved .config, all
> was peachy.
> 
> Methinks dontdiff bit me.

After a quick look:
[sam@neptun x86.git]$ find -name '*.i'
./include/asm-x86/alternative-asm_64.i
./include/asm-x86/alternative-asm_32.i
./include/asm-x86/frame.i
./include/asm-x86/alternative-asm.i
./include/asm-um/frame.i
./include/asm-um/alternative-asm.i
[sam@neptun x86.git]$ grep '*.i' Documentation/dontdiff 
*.i

But I cannot see how this could result in the bug you
reported..
Anyway at least one dontdiff buglet - or we should preferably
drop the .i files in the kernel src.

	Sam
