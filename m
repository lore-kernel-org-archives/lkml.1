Return-Path: <linux-kernel-owner+w=401wt.eu-S1764474AbYA2AI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764474AbYA2AI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 19:08:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbYA2AIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 19:08:50 -0500
Received: from iabervon.org ([66.92.72.58]:34968 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646AbYA2AIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 19:08:49 -0500
Date: Mon, 28 Jan 2008 19:08:47 -0500 (EST)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Mike Frysinger <vapier.adi@gmail.com>
cc: richard kennedy <richard@rsk.demon.co.uk>, bryan.wu@analog.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bryan Wu <cooloney.lkml@gmail.com>
Subject: Re: [rfc] exposing MMR's of on-chip peripherals for debugging
 purposes
In-Reply-To: <8bd0f97a0801280510q42dbf5d3i947877b7e3454fe1@mail.gmail.com>
Message-ID: <alpine.LNX.1.00.0801281901130.13593@iabervon.org>
References: <8bd0f97a0801280216x56d52028s2ea247dd969e85e2@mail.gmail.com>  <1201516811.7547.46.camel@roc-laptop>  <8bd0f97a0801280306k5dc4410eu208bc55f1975ceb8@mail.gmail.com>  <479DD2F3.6020209@rsk.demon.co.uk>
 <8bd0f97a0801280510q42dbf5d3i947877b7e3454fe1@mail.gmail.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008, Mike Frysinger wrote:

> On Jan 28, 2008 8:04 AM, richard kennedy <richard@rsk.demon.co.uk> wrote:
> > Mike Frysinger wrote:
> > > On Jan 28, 2008 5:40 AM, Bryan Wu <bryan.wu@analog.com> wrote:
> > >> On Mon, 2008-01-28 at 05:16 -0500, Mike Frysinger wrote:
> > >>> the trouble is that this file currently weighs in at ~1.8 megs.  this
> > >>> is because it contains all the information for all Blackfin processors
> > >>> we support (which currently, is about ~23 variants).  it's only going
> > >>> to get bigger as we support more.  Bryan cringes at the thought of
> > >>> submitting it to LKML :).  so i'm fishing around for alternatives ...
> > >>> the code was originally developed against 2.6.21, so UIO was not a
> > >>> possibility.  i'm still not sure if it is ... i'd have to research it
> > >>> a bit more and play with things.
> > >> The main reason I am not willing to submit this to mainline is the file
> > >> size. It's almost the biggest file in the kernel source. And it will be
> > >> bigger and bigger when more and more new Blackfin processors supported
> > >> by Linux kernel.
> > >
> > > a quick check of current git shows it is significantly larger than any other ;)
> > >
> > >> My suggestion is:
> > >> Or more deeper thought:
> > >>  - we don't need all the MMR setup at the same time for debugging. for example, maybe for some developer, he/she only needs one driver MMR for debugging such as watchdog/usb/spi/i2c ....
> > >
> > > splitting things up doesnt really address the original issue: there's
> > > a lot of info here to be kept in the kernel
> > >
> > >>  - How about split the debug MMR table to each drivers or processors?
> > >>  - watchdog driver implements a debug FS interface for debugging watchdog MMR and other drivers implement their own things.
> > >
> > > this had been mentioned before as a possibility but shot down.  you do
> > > not want to tie the creation of these debug files to anything as the
> > > prevents independent development of any other drivers/application that
> > > use the same peripheral.
> >
> > there is a lot of duplication in your file, but you could slim it down a
> > bit if thats the only objection.
> 
> i imagine there's a ton of duplication ... the file is auto-generated
> from XML files, so i could take a look at the autogeneration producing
> unified code.

Could you submit the XML files and the autogeneration code? The C file 
isn't really source. Not only is it big, it'll probably change around a 
whole lot when you make small changes to your process, be hard to review, 
etc.

	-Daniel
*This .sig left intentionally blank*
