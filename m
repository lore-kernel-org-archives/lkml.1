Return-Path: <linux-kernel-owner+w=401wt.eu-S934242AbXEVL1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934242AbXEVL1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 07:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758540AbXEVL1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 07:27:48 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:37628 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375AbXEVL1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 07:27:47 -0400
Date: Tue, 22 May 2007 09:39:35 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -ak] Fix missing include
Message-ID: <20070522073935.GA8896@uranus.ravnborg.org>
References: <1179777839.12708.42.camel@chaos> <200705220820.11688.ak@suse.de> <1179818895.12708.98.camel@chaos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179818895.12708.98.camel@chaos>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 09:28:15AM +0200, Thomas Gleixner wrote:
> On Tue, 2007-05-22 at 08:20 +0200, Andi Kleen wrote:
> > On Monday 21 May 2007 22:03, Thomas Gleixner wrote:
> > > ftp://firstfloor.org/pub/ak/x86_64/quilt/x86_64-2.6.22-rc2-070521-1.bz2
> > >
> > > explodes in various places due to missing defines of __cold. We can't
> > > rely on the assumption that linux/compiler.h is included magically
> > > before bug.h is included. Include it explicitely.
> > 
> > Hmm, somehow it worked here. Perhaps longer term it would be a good
> > idea to turn compiler.h into an -include
> 
> Might be not a bad idea. > 300 files include it directly and it's
> included from sched.h & co as well.

How about a file like:
include/linux/always_include.h

This file could then include autoconf.h + compiler.h
So we avoid an even longer gcc commandline.

	Sam
