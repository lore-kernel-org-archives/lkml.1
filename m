Return-Path: <linux-kernel-owner+w=401wt.eu-S1759186AbZAVWvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759186AbZAVWvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 17:51:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbZAVWuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 17:50:52 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34603 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbZAVWuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 17:50:51 -0500
Date: Thu, 22 Jan 2009 17:50:26 -0500
From: Kyle McMartin <kyle@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>, J?rn Engel <joern@logfs.org>,
       David Brown <lkml@davidb.org>, Phil Oester <kernel@linuxace.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       Christoph Hellwig <hch@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
Message-ID: <20090122225025.GA21879@bombadil.infradead.org>
Reply-To: kyle@infradead.org
References: <20090109211937.GA14342@logfs.org> <20090110124335.GB30744@elte.hu> <20090110165033.GA23943@logfs.org> <20090110101235.7ca24c44.akpm@linux-foundation.org> <20090110221528.GA31774@elte.hu> <Pine.LNX.4.64.0901111022590.30201@anakin> <20090111153920.GC7401@elte.hu> <20090111163018.GA9300@suse.de> <20090122215041.GA29369@redhat.com> <20090122215817.GA27609@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090122215817.GA27609@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Playing devil's advocate here...

On Thu, Jan 22, 2009 at 01:58:17PM -0800, Greg KH wrote:
> > * The fallout of staging is already starting to drift into distros.
> >   Within a week of Fedora shipping a kernel that had staging/
> >   we had requests to enable drivers from it.
> >   And of course, those drivers were garbage.
> >   This is only going to increase as time goes on.
> 
> That's up to you as a distro to handle, not much I can do there.
> 
> But, if you want a recommendation, some of the drivers in staging came
> from the Fedora kernel tree, so you should be enabling them :)
> 

Just at76, I think.

> What is wrong with it?  Bugs are getting fixed, people are getting use
> out of their hardware (hell, Linus is even using one of the drivers),
> and lots of developers are cutting their teeth on helping out.
> 

Why does it need to be upstream for someone to cut their teeth helping
out?

> If you don't like it, just disable it in your kernel packages, or
> instantly close out the bugs.  The drivers in staging has already helped
> out some distros by virtue of including newer drivers than they were
> mistakenly using at the time (Ubuntu, I'm looking at you...)
> 
> And again, it's helped out users, which is the most important thing
> here.
> 

What concerns me is the precedent this sets. If "getting something
upstream" now means "getting something into staging" then we've failed
our users since there's no longer any motivation for a vendor to invest
in all but the most cursory work on a Linux driver.

I think we have higher standards to live up to than that.

I agree that this is a much better plan than all the distros
individually collecting all the shit drivers themselves and (well, for
some of them) fixing the most egregious of crap and not getting fixes
back upstream because they've all frozen on different versions. But
still.

(I also think TAINT_CRAP is kind of an insulting name for things which
are really Linux-targetted features that just haven't had thorough
enough review. Evgeniy Polyakov's work comes to mind... it's really
comparing apples to a bunch of festering pieces of turd. While I'm sure
he's happy to have gotten his stuff in for more review, is it likely to
actually get more review than it would with weekly mailing list
postings? Maybe, who am I to say... I do think labelling his work crap
by virtue of the directory it resides in is fairly silly.)

</rant off>

Yeah, I realize it's fairly hypocritical for me to criticize given I
used to work on Ubuntu, but if it makes anyone feel any better, I didn't
like the idea of shipping things we wouldn't possibly support there
either.

While it is nice to justify things as "but users want it" they also
don't want a driver that reads files out of /etc and panics their kernel
or trashes their data. Which is why we won't enable this in Fedora. We
have enough maintenance burden with the utter horrowshow drivers we
claim as "maintained" in mainline already. If people really think having
something in mainline increases the odds something will get cleaned up,
I urge them to look at any scsi, network, or isdn driver from more than
five years ago. Make sure you bring a barf bag.

In summary, I don't know, this is one of those damned if you do, damned
if you don't paradoxes. ;-) But if you suck in a driver that barfs all
over your filesystem, because it was allowed to be turned in with zero
review, are you going to be the one to tell the user "ha ha, sucks to be
you?" I sure wouldn't want to be.

regards, Kyle
