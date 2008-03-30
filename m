Return-Path: <linux-kernel-owner+w=401wt.eu-S1755373AbYC3WW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373AbYC3WW5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 18:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751087AbYC3WWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 18:22:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49357 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbYC3WWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 18:22:49 -0400
Date: Sun, 30 Mar 2008 15:22:28 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] evdev: Release eventual input device grabs when
	getting disconnected
Message-ID: <20080330222228.GA2419@kroah.com>
References: <20080330184259.GB21375@atjola.homenet> <alpine.LFD.1.00.0803301448190.14670@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803301448190.14670@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2008 at 02:51:02PM -0700, Linus Torvalds wrote:
> 
> 
> On Sun, 30 Mar 2008, Bj?rn Steinbrink wrote:
> >
> > I can't reproduce the bug on my UP box and currently can't afford
> > crashing my SMP box (all the oopses seem to come from SMP kernels, so I
> > guess it needs SMP to crash), so while this doesn't show any new
> > problems, I can't tell whether it actually fixes anything. Testers
> > welcome!
> 
> Ok, I applied this because I will do an -rc8 today or tomorrow, but I 
> really really hope somebody can figure out what made this all start to 
> trigger. It does smell like some core device layer change, because we do 
> not seem to have a lot of changes since 2.6.24 in evdev.c and input.c that 
> seem relevant.
> 
> Greg, are there any refcounting changes that would cause the input devices 
> to be free'd earlier or something?

Earlier?  No, not that I know of at all, as long as the reference
counting logic was correct originally.  All of the problems we have been
fixing were ones where we accidentally were grabbing too many references
and then wondering why things were not getting cleaned up properly as
the kobject rework exposed these problems making them more obvious.

I haven't heard of the opposite happening.  Anything that I can try to
test for here, I have a lot of removable input devices to test with.

thanks,

greg k-h
