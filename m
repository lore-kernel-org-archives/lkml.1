Return-Path: <linux-kernel-owner+w=401wt.eu-S1762317AbYA2Bv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762317AbYA2Bv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 20:51:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbYA2Bvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 20:51:49 -0500
Received: from iabervon.org ([66.92.72.58]:35361 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330AbYA2Bvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 20:51:48 -0500
Date: Mon, 28 Jan 2008 20:51:45 -0500 (EST)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Gene Heskett <gene.heskett@gmail.com>
cc: Richard Heck <rgheck@bobjweil.com>, Zan Lynx <zlynx@acm.org>,
       Calvin Walton <calvin.walton@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ide Mailing list <linux-ide@vger.kernel.org>
Subject: Re: Problem with ata layer in 2.6.24
In-Reply-To: <200801282031.58429.gene.heskett@gmail.com>
Message-ID: <alpine.LNX.1.00.0801282040080.13593@iabervon.org>
References: <200801272122.21823.gene.heskett@gmail.com> <200801281905.35278.gene.heskett@gmail.com> <alpine.LNX.1.00.0801281909170.13593@iabervon.org> <200801282031.58429.gene.heskett@gmail.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008, Gene Heskett wrote:

> On Monday 28 January 2008, Daniel Barkalow wrote:
> >On Mon, 28 Jan 2008, Gene Heskett wrote:
> >> On Monday 28 January 2008, Daniel Barkalow wrote:
> >> >Building this and installing it along with the appropriate initrd (which
> >> >might be handled by Fedora's install scripts)
> >>
> >> Or mine, which I've been using for years.
> >
> >You're ahead of a surprising number of people, including me, if you
> >understand making initrds.
> 
> In my script, its one line:
> mkinitrd -f initrd-$VER.img $VER && \
> 
> where $VER is the shell variable I edit to = the version number, located at 
> the top of the script.
> 
> Unforch, its failing:
> No module pata_amd found for kernel 2.6.24, aborting.
> 
> This is with pata_amd turned off and its counterpart under ATA/RLL/etc turned 
> on.  So something is still dependent on it. 

That looks like something in the guts of the initrd; it probably thinks 
you need pata_amd and it's unhappy that you don't have it.

Actually, another thing to try is making the ATA/etc one be "y" and 
pata_amd be "m". Most likely, this should lead to the ATA one claiming the 
drive before the module is loaded (but the module would be loaded later, 
to avoid upsetting the initrd); you should be able to tell from dmesg (or 
/dev, for that matter) which one got it, and I think built-in drivers will 
claim everything they can before an initrd gets loaded.

> I do have one sata drive, on an accessory card in the box, so I need the 
> rest of the sata_sil and friends stuff. 

Assuming it isn't picking up your hard drive, which it isn't, that 
shouldn't matter.

	-Daniel
*This .sig left intentionally blank*
