Return-Path: <linux-kernel-owner+w=401wt.eu-S932089AbXIMTSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089AbXIMTSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 15:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762090AbXIMTSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 15:18:15 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:50202 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755451AbXIMTSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 15:18:14 -0400
Date: Thu, 13 Sep 2007 21:19:38 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Chris Wedgwood <cw@f00f.org>, Oleg Verych <olecom@flower.upol.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, davej@redhat.com,
       Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [RFC PATCH] Add a 'minimal tree install' target
Message-ID: <20070913191938.GD27146@uranus.ravnborg.org>
References: <20070912232534.GA26868@puku.stupidest.org> <20070913183359.GA27146@uranus.ravnborg.org> <20070913185753.GA9259@puku.stupidest.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070913185753.GA9259@puku.stupidest.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris.

Thanks for working on this.
 
> > > +if [ "$srctree" != "$objtree" ] ; then
> > > +    cp --parents $(find -type f -name "Makefile*" -o -name "Kconfig*" -not -ipath "$objtree/*Makefile" ) ${tgtdir}
> >                                                                                                ^
> > Why this wildcard??? (objtree/>*<Makefile)
> > Seems to be a typing error.
> 
> no, it's so we catch things like
> 
> linux/build/Makefile
> 
>  *and*
> 
> linux/build/foo/bar/Makefile
Obviously - I missed the find when I looked.
Thanks for the explanation. And no comments needed in the script -
I should just have read the full command line.

> 
> > > +#rm -rf ${tgtdir}/Documentation
> > Remove this line since it is commented out
> 
> right, actually, it can be uncommented but the 'make help' fails; i'm
> not sure if we need make help to work since most of the other targets
> won't anyhow
> 
> so should i remove it (leaving 'make help' as usable) or remove it?
Un-comment it so we do not break make help.

> > Something less hardcoded are preferred. Maybe like:
> > cp -a `ls | grep -v ^asm` asm-generic $(tgtdir}/include
> 
> ok (though i'm not a big fan of ls | grep as a rule, it tends to be
> fragile when people do dumb things)

find . -maxdepth 1 -! -name 'asm*'
seems to do the trick and it is better than ls.

> 
>     sed -n "s/^ALTARCH[[:space:]]:=[[:space:]]\(.*$\)\+/\1/p"
> 
> (i'm sure there is a better way though)

Oleg (added to mail) - you are quite confident in sed et al.
Let us know if there is a simpler way.

(We want to pick i386 from include/asm-x86_64/Kbuild
and similar for the architectures that uses ARCHDEF).

	Sam
