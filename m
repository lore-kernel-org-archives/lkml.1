Return-Path: <linux-kernel-owner+w=401wt.eu-S1761001AbXGMATe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761001AbXGMATe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 20:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758772AbXGMAT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 20:19:28 -0400
Received: from mail.suse.de ([195.135.220.2]:37677 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756165AbXGMAT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 20:19:27 -0400
Date: Thu, 12 Jul 2007 17:19:06 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [GIT PATCH] USB patches for 2.6.22
Message-ID: <20070713001906.GA24272@suse.de>
References: <20070712234233.GA22339@kroah.com> <alpine.LFD.0.999.0707121647420.20061@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707121647420.20061@woody.linux-foundation.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 05:03:46PM -0700, Linus Torvalds wrote:
> 
> On Thu, 12 Jul 2007, Greg KH wrote:
> >
> > Here are a bunch of USB patches and fixes against your 2.6.22 git tree.
> 
> This also seems to contain some *totally*pointless* config variable 
> changes, that actually break simple things like "make oldconfig".
> 
> This commit is insane: acb11c8b8020f1f1b2545152020675ef32d09a58 "USB: fix 
> gregkh-usb-usb-use-menuconfig-objects"
> 
> It fixes nothing at all, quite the reverse. It makes the default be 
> somethign that breaks everything, and more irritatingly, even if you 
> answer 'y' (against the default), it breaks "make oldconfig", which will 
> have ignored all the old options and now will ask you for all of them 
> again.
> 
> Yeah, that second part may be a "make oldconfig" bug, but regardless, 
> these kinds of Kconfig changes are BAD, BAD, BAD!
> 
> I hate how people do just stupid things to "clean up" config files 
> (renaming config options etc), apparently never even bothering to think 
> about whether a question is sane or not, or whether normal users want to 
> see it or not.
> 
> I know I'm not the only one who does "make oldconfig". Answering the same 
> questions over and over again is not something *anybody* wants to do.
> 
> So please stop this madness. I've reverted the change that left the 
> menuconfig entry without a default, which at least fixes "make oldconfig", 
> but I just found this really irritating. I can pretty much guarantee that 
> nobody actually *tested* this change, did they?

Hm, odd.  Ok, I see how it went.

I tested it _before_ that change went in with make oldconfig, and then
later after that patch went in.  If you do that (running oldconfig
between the patches) you do not get asked the zillion different USB
questions.  If, however, you just start with all of the patches at once,
it becomes annoying as hell.

So sorry about this fix, I agree with the revert, and am going to have
to try to figure out some way to check for things like this in the
future (rolling back .config files to the last version or something...)

thanks,

greg k-h
