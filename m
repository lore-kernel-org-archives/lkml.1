Return-Path: <linux-kernel-owner+w=401wt.eu-S932398AbXGMAEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398AbXGMAEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 20:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758562AbXGMAEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 20:04:16 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58628 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758736AbXGMAEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 20:04:15 -0400
Date: Thu, 12 Jul 2007 17:03:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       Jan Engelhardt <jengelh@computergmbh.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [GIT PATCH] USB patches for 2.6.22
In-Reply-To: <20070712234233.GA22339@kroah.com>
Message-ID: <alpine.LFD.0.999.0707121647420.20061@woody.linux-foundation.org>
References: <20070712234233.GA22339@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 12 Jul 2007, Greg KH wrote:
>
> Here are a bunch of USB patches and fixes against your 2.6.22 git tree.

This also seems to contain some *totally*pointless* config variable 
changes, that actually break simple things like "make oldconfig".

This commit is insane: acb11c8b8020f1f1b2545152020675ef32d09a58 "USB: fix 
gregkh-usb-usb-use-menuconfig-objects"

It fixes nothing at all, quite the reverse. It makes the default be 
somethign that breaks everything, and more irritatingly, even if you 
answer 'y' (against the default), it breaks "make oldconfig", which will 
have ignored all the old options and now will ask you for all of them 
again.

Yeah, that second part may be a "make oldconfig" bug, but regardless, 
these kinds of Kconfig changes are BAD, BAD, BAD!

I hate how people do just stupid things to "clean up" config files 
(renaming config options etc), apparently never even bothering to think 
about whether a question is sane or not, or whether normal users want to 
see it or not.

I know I'm not the only one who does "make oldconfig". Answering the same 
questions over and over again is not something *anybody* wants to do.

So please stop this madness. I've reverted the change that left the 
menuconfig entry without a default, which at least fixes "make oldconfig", 
but I just found this really irritating. I can pretty much guarantee that 
nobody actually *tested* this change, did they?

		Linus
