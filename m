Return-Path: <linux-kernel-owner+w=401wt.eu-S939873AbXHIN1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939873AbXHIN1k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 09:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937323AbXHIN1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 09:27:32 -0400
Received: from alnrmhc11.comcast.net ([206.18.177.51]:55532 "EHLO
	alnrmhc11.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936261AbXHIN1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 09:27:32 -0400
From: cholvenstot@comcast.net
To: "Benoit Boissinot" <bboissin@gmail.com>
Cc: "Chris Holvenstot" <saltydog@houston.rr.com>,
       "kernel list" <linux-kernel@vger.kernel.org>
Subject: Re: Kernel / Fliesystem Error
Date: Thu, 09 Aug 2007 13:27:31 +0000
Message-Id: <080920071327.29425.46BB1642000EB0AD000072F122165258569B019B9C020A900401080C@comcast.net>
X-Mailer: AT&T Message Center Version 1 (Oct  4 2006)
X-Authenticated-Sender: Y2hvbHZlbnN0b3RAY29tY2FzdC5uZXQ=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benoit - 

Thank you for the response - I think that you are correct in your analysis that the probem has something to do with timing and not with EXT3 itself.  

However, I have been thinking this through and this cold little shadow is now hanging over my head - there was a difference in the process used to build the system between 2.6.22.1 and 2.6.23-rcx and I would like to account for it before anyone burns their valuable time chasing ghosts I may have created.,

Specifically I am refering to the process I used ot build the initrd image.

Traditionally, I used the old standby mkinitrd whcih still builds a useable image.  However, when tracking down a series of messages about a failure to mount devfs devices I discovered that the approved method is now to use mkinitramfs.

And mkinitramfs did eliminate the messages about devfs just as the documentation said it would.

However, the initrd image for my 2.6.22.1 was built using the older mkinitrd command and it DOES NOT seem to have the timestamp issue buring boot.  With the 2.23.6-rcx series of kernels I used the mkinitramfs process - and my 2.6.23-rcx kernels is where I am seeing the problem.

I am at work now and don't have a way of seeing the early boot messages on my system at home.  When I get home this afternoon I will build the initrd image for the 2.6.22.1 system using the mkinitramfs command and I will post an updated status at that time.

Chris
 -------------- Original message ----------------------
From: "Benoit Boissinot" <bboissin@gmail.com>
> On 8/9/07, Chris Holvenstot <cholvenstot@comcast.net> wrote:
> > > Chris Snook wrote:
> > >
> > >The problem here is that your clock is wrong either at mount (boot)
> > >time or unmount (shutdown) time. There's nothing wrong with ext3,
> > >except that it happens to be noticing this condition.
> >
> > 1.  This happens even when the system is rebooted via the shutdown -r
> > command - not much time for my fat fingers to get in there and dork up
> > the system clock.
> >
> > 2.  As I stated in the original note, this does NOT happen with kernel
> > 2.6.22.1 - so far I have only seen it with the 2.6.23-rc1, rc2, and
> > rc2-git1 kernels.
> >
> 
> But very likely time keeping was broken between .22 and .23-rc.
> Probably not ext3.
> 
> regards,
> 
> Benoit

