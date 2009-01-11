Return-Path: <linux-kernel-owner+w=401wt.eu-S1753331AbZAKW1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbZAKW1W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 17:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbZAKW1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 17:27:06 -0500
Received: from iabervon.org ([66.92.72.58]:56963 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbZAKW1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 17:27:05 -0500
Date: Sun, 11 Jan 2009 17:27:01 -0500 (EST)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Christian Borntraeger <borntraeger@de.ibm.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Johannes Schindelin <Johannes.Schindelin@gmx.de>, git@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: current git kernel has strange problems during bisect
In-Reply-To: <200901112239.20306.borntraeger@de.ibm.com>
Message-ID: <alpine.LNX.1.00.0901111646040.19665@iabervon.org>
References: <200901111602.53082.borntraeger@de.ibm.com> <20090111194258.GA4840@uranus.ravnborg.org> <alpine.LFD.2.00.0901111200330.6528@localhost.localdomain> <200901112239.20306.borntraeger@de.ibm.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Jan 2009, Christian Borntraeger wrote:

> Am Sonntag 11 Januar 2009 schrieb Linus Torvalds:
> > Well, you don't actually have to mark that semi-random one as good either. 
> > What you can do is to just mark anything that _only_ contains fs/btrfs as 
> > good. IOW, you don't have to know the magic number - you just have to be 
> > told that "oh, if you only have btrfs files, and you're not actively 
> > bisecting a btrfs bug, just do 'git bisect good' and continue".
> 
> That should work.
> 
> <rant>
> Still, I am a bit frustrated. During this weekend I reported 2 regressions 
> (wlan and ata)  and I still try to find out why suspend/resume stopped 
> working. In the meantime I have identified 2 patches (one was already known, 
> I reported the 2nd to the usb maintainers) after 2.6.28 that caused suspend 
> to ram regressions. In rc1 S2R was broken again. So I tried bisecting the 
> third patch - which finally brought me to the btrfs bisect problem.
> 
> For me, this was the most annoying  merge window ever.
> 
> In my opinion we should really avoid subtree merges in the future as a curtesy 
> to people who do the uncool work of testing, problem tracking and bisecting. 
> </rant>

I think hitting a version without the actual kernel source in it should 
actually make bisecting easier, not harder; you can say without even 
building the kernel that that version doesn't have the problem you're 
trying to find, because it doesn't have anything in it.

The alternative to having that part of the tree empty would be to stick in 
some kernel version there (probably 2.6.28), and then you'd build and test 
2.6.28 again, completely wasting a bunch of time.

Probably the bisect documentation or messages need to make it clear what 
you should do when you land on this sort of commit.

	-Daniel
*This .sig left intentionally blank*
