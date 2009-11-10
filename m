Return-Path: <linux-kernel-owner+w=401wt.eu-S1751548AbZKJF1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548AbZKJF1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 00:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbZKJF1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 00:27:24 -0500
Received: from 1wt.eu ([62.212.114.60]:50881 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864AbZKJF1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 00:27:24 -0500
Date: Tue, 10 Nov 2009 06:27:11 +0100
From: Willy Tarreau <w@1wt.eu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>, Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091110052711.GA15338@1wt.eu>
References: <4AF4526B.4060101@zytor.com> <40101cc30911061418w357b74d8i3bf9a9537de052d4@mail.gmail.com> <20091108173708.GF1372@ucw.cz> <40101cc30911080940s18eb26bbg641beeaddbc25c3d@mail.gmail.com> <20091108181016.GB32364@elf.ucw.cz> <alpine.DEB.2.00.0911082026430.30789@aurora.sdinet.de> <20091108193618.GB4186@elf.ucw.cz> <40101cc30911081147j77f7b81o86f2cc5a869aca1f@mail.gmail.com> <20091108195158.GD4186@elf.ucw.cz> <20091108200852.7f2cf092@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091108200852.7f2cf092@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 08, 2009 at 08:08:52PM +0000, Alan Cox wrote:
> > SIGILL is easier to debug than NOPL mysteriously taking 100x time it
> > should, sorry.
> 
> And a working 686 distribution is a great deal more useful to end users,
> who outnumber you by a few million to one. It's a very sensible patch, or
> perhaps you'd prefer we didn't say. And you forget the user "debug" for
> a Geode + i686 without this will be "it hangs when I try and boot the
> install CD"
> 
> It would probably also be worth having cmov fixups for the VIA C3 as well.

Agreed! I've been using the cmov patch on my kernels for years and
it has helped a lot. It isn't *that* slow and allows you to boot a
machine which wouldn't boot otherwise. Also, I have memories about
the C3 supporting register-to-register CMOV but faulting only on
register-to-memory, which is less common and makes the patch even
more useful.

I'm very happy that people finally consider instruction emulation
in kernel. Many other systems do that to help porting code between
CPUs, and it's easier to work with that than to have builds for a
large variety of CPUs in the same family. I'm sure that many distros
would prefer to provide a build optimized for the fastest CPUs around
and support the other ones in compatiblity mode than optimize for the
smallest ones in order to support everyone.

Also, I think that if we start adding emulation, a global and per-task
counter would immensely help to know what processes make intensive use
of emulation.

Willy

