Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334AbZJQSZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbZJQSZQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 14:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZJQSZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 14:25:15 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45500 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbZJQSZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 14:25:14 -0400
Date: Sat, 17 Oct 2009 20:25:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: Re: 32-rc1: "CROSS_COMPILE changed" message breaks compilation
Message-ID: <20091017182511.GC16532@elf.ucw.cz>
References: <20090928175605.GB28514@elf.ucw.cz>
 <20090928190841.GA12004@merkur.ravnborg.org>
 <20090928192536.GE28514@elf.ucw.cz>
 <20091011212757.GA2768@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091011212757.GA2768@merkur.ravnborg.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-10-11 23:27:57, Sam Ravnborg wrote:
> On Mon, Sep 28, 2009 at 09:25:36PM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > > After update to 2.6.32-rc1, I'm getting
> > > > 
> > > > "Makefile:197: *** CROSS_COMPILE changed from "ccache" to to "ccache ". Use "make mrproper" to fix it up. Stop.
> > > > 
> > > > Note that the message has typo in it ("to to")... What is worse, the
> > > > message triggers even when I try to run make mrproper. Ouch.
> > > 
> > > The massage is changed in kbuild-fixes.git - but it addresses only ARCH=
> > > 
> > > As a followup to your other mails:
> > > The reason to use "make mrproper" is that when ARCH or CROSS_COMPILE changes
> > > you have generally either decided to build for a new architecture or
> > > you have changed the way you build the kernel (new toolchain or whatever).
> > > So to clean up using "make mrproper" is perfectly justified.
> > > 
> > > The target group that uses CROSS_COMPILE to enable ccache are using
> > > CROSS_COMPILE is a way it is not designed for so they should expect that it
> > > is not a perfect match.
> > 
> > What is the recommended way to run ccache, then?
> ccache is a frontend to gcc - so I would have expected
> you would use: 
> 
>     make CC="ccache gcc"
> 
> Or does ccache also benefit ld and as and the other that receive
> the $(CROSS_COMPILE) prefix?

You are right that I don't strictly need ccache for anything but cc.

But anyway, check was buggy; I had CROSS_COMPILE="ccache ", and the
space at the end broke it.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
