Return-Path: <linux-kernel-owner+w=401wt.eu-S1753399AbZJQSle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbZJQSle (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 14:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbZJQSld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 14:41:33 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:59984 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbZJQSlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 14:41:32 -0400
Date: Sat, 17 Oct 2009 20:41:36 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: Re: 32-rc1: "CROSS_COMPILE changed" message breaks compilation
Message-ID: <20091017184136.GA13279@merkur.ravnborg.org>
References: <20090928175605.GB28514@elf.ucw.cz> <20090928190841.GA12004@merkur.ravnborg.org> <20090928192536.GE28514@elf.ucw.cz> <20091011212757.GA2768@merkur.ravnborg.org> <20091017182511.GC16532@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091017182511.GC16532@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 17, 2009 at 08:25:12PM +0200, Pavel Machek wrote:
> On Sun 2009-10-11 23:27:57, Sam Ravnborg wrote:
> > On Mon, Sep 28, 2009 at 09:25:36PM +0200, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > > After update to 2.6.32-rc1, I'm getting
> > > > > 
> > > > > "Makefile:197: *** CROSS_COMPILE changed from "ccache" to to "ccache ". Use "make mrproper" to fix it up. Stop.
> > > > > 
> > > > > Note that the message has typo in it ("to to")... What is worse, the
> > > > > message triggers even when I try to run make mrproper. Ouch.
> > > > 
> > > > The massage is changed in kbuild-fixes.git - but it addresses only ARCH=
> > > > 
> > > > As a followup to your other mails:
> > > > The reason to use "make mrproper" is that when ARCH or CROSS_COMPILE changes
> > > > you have generally either decided to build for a new architecture or
> > > > you have changed the way you build the kernel (new toolchain or whatever).
> > > > So to clean up using "make mrproper" is perfectly justified.
> > > > 
> > > > The target group that uses CROSS_COMPILE to enable ccache are using
> > > > CROSS_COMPILE is a way it is not designed for so they should expect that it
> > > > is not a perfect match.
> > > 
> > > What is the recommended way to run ccache, then?
> > ccache is a frontend to gcc - so I would have expected
> > you would use: 
> > 
> >     make CC="ccache gcc"
> > 
> > Or does ccache also benefit ld and as and the other that receive
> > the $(CROSS_COMPILE) prefix?
> 
> You are right that I don't strictly need ccache for anything but cc.
> 
> But anyway, check was buggy; I had CROSS_COMPILE="ccache ", and the
> space at the end broke it.

I assume you did not read the other mail relevant to this topic.
The patch in question has been reverted.

	Sam
