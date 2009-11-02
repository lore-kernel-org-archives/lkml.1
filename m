Return-Path: <linux-kernel-owner+w=401wt.eu-S1756603AbZKBSvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603AbZKBSvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 13:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbZKBSvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 13:51:38 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41789 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755911AbZKBSvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 13:51:37 -0500
Date: Mon, 2 Nov 2009 18:53:15 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Ryan C. Gordon" <icculus@icculus.org>
Cc: =?ISO-8859-14?B?TeVucyBSdWxsZ+VyZA==?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: FatELF patches...
Message-ID: <20091102185315.6326e148@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.OSX.1.10.0911021057450.464@caridad.icculuslan>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan>
	<1257103201.2865.6.camel@chumley>
	<yw1xy6mq0z2s.fsf@unicorn.mansr.com>
	<alpine.OSX.1.10.0911011540400.53392@caridad.local>
	<20091102000147.424f104b@lxorguk.ukuu.org.uk>
	<alpine.OSX.1.10.0911021057450.464@caridad.icculuslan>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sure, this doesn't work for everyone, but this list isn't meant to be a 

You've not shown a single meaningful use case yet.

> some of the same issues, they cause other issues. The fact that Debian is 
> now talking about "multiarch" shows that they've experienced some of these 
> problems, too, despite having a world-class package manager.

No it means that Debian is finally catching up with rpm on this issue,
where it has been solved for years.

> 
> > - Separate lib, lib32, lib64
> > 	- So you have one file with 3 files in it rather than three files
> > 	  with one file in them. Directories were invented for a reason
> 
> We covered this when talking about shell scripts.

Without providing a justification

> I'm sure, but I'm not sure the increase is a staggering amount. We're not 
> talking about making all packages into FatELF binaries.

How will you jhandle cross package dependancies

> > 	- Stops users only having 32bit libs for some packages
> 
> Is that a serious concern?

Yes from a space perspective and a minimising updates perspective.

> > - Third party packagers no longer have to publish multiple rpm/deb etc
> > 	- By vastly increasing download size
> > 	- By making updates vastly bigger
> 
> It's true that /bin/ls would double in size (although I'm sure at least 
> the download saves some of this in compression). But how much of, say, 
> Gnome or OpenOffice or Doom 3 is executable code? These things would be 
> nowhere near "vastly" bigger.

Guess what: all the data files for Doom and OpenOffice are already
packaged separately as are many of the gnome ones, or automagically
shared by the two rpm packages.

> 
> > 	- Assumes data files are not dependant on binary (often not true)
> 
> Turns out that /usr/sbin/hald's cache file was. That would need to be 
> fixed, which is trivial, but in my virtual machine test I had it delete 
> and regenerate the file on each boot as a fast workaround.
> 
> The rest of the Ubuntu install boots and runs. This is millions of lines 
> of code that does not depend on the byte order, alignment, and word size 
> for its data files.

That you've noticed. But you've not done any formal testing with tens of
thousands of users so you've not done more than the "hey mummy it boots"
test (which is about one point over the Linus 'it might compile' stage)
 
> I don't claim to be an expert on the inner workings of every package you 
> would find on a Linux system, but like you, I expected there would be a 
> lot of things to fix. It turns out that "often not true" just turned out 
> to actually _not_ be true at all.

You need an expert on the inner workings of each package to review and
test them. Fortunately that work is already done- by the rpm packagers
for all the distros

> > - The ELF OSABI for your system changes someday?
> > 	- We already handle that
> 
> Do we? I grepped for OSABI in the 2.6.31 sources, and can't find anywhere, 
> outside of my FatELF patches, where we check an ELF file's OSABI or OSABI 
> version at all.

ARM has migrated ABI at least once.

> Where do we handle an ABI change gracefully? Am I misunderstanding the 
> code?

You add code for the migration as needed, in the distro

> single point, but you can't see a scenario where this adds a benefit? Even 
> in a world that's still running 32-bit web browsers on _every major 
> operating system_ because some crucial plugins aren't 64-bit yet?

Your distro must be out of date or a bit backward. Good ones thunk those
or run them in a different process (which is a very good idea for quality
reasons as well as security)

> 
> > - Ship web browser plugins that work out of the box with multiple
> >   platforms.
> > 	- yum install just works, and there is a search path in firefox
> > 	  etc
> 
> So it's better to have a thousand little unique solutions to the same 
> problem? 

We have one solution - package management. You want to add the extra one.

> it doesn't change the fact that I downloaded the wrong nvidia drivers the 
> other day because I accidentally grabbed the ia32 package instead of the 
> amd64 one. So much for saving bandwidth.

You mean your package manager didn't do it for you ? Anyway kernel
drivers are dependant on about 1500 variables and 1500! is a very very
large FatELF binary so it won't work.

> Not really. compat_binfmt_elf will run legacy binaries on new systems, but 
> not vice versa. The goal is having something that will let it work on both 
> without having to go through a package manager infrastructure.

See binfmt_misc. In fact you can probably do your ELF hacks in userspace
that way if you really must.

> In a world where terrabyte hard drives are cheap consumer-level 
> commodities, the tradeoff seems like a complete no-brainer to me.

Except that
- we are moving away from rotating storage for primary media
- flash still costs rather more
- virtual machines mean that disk space is now a real cost again as is RAM

> version. It's easier on me, I have other projects to work on, and too bad 
> for you. Granted, the x86_64 version _works_ on Linux, but shipping it is 
> a serious pain, so it just won't ship.

Distro problem, in the open source world someone will package it.

> That is anecdotal, and I apologize for that. But I'm not the only 
> developer that's not in an apt repository, and all of these rebuttals are 
> anecdotal: "I just use yum [...because I don't personally care about 
> Debian users]."

No. See yum/rpm demonstrates that it can be done right. Debian has fallen
a bit behind on that issue. We know it can be done right, and that tells
us that the Debian tools will eventually catch up and also do it right.

You have a solution (quite a nicely programmed one) in search of a
problem, and with patent concerns. That's a complete non-flier for the
kernel. It's not a dumping ground for neat toys and it would be several
gigabytes of code if it was.

You are also ignoring the other inconvenient detail. The architecture
selection used even by package managers is far more complex than i386 v
x86_64. Some distros build i686, some i686 optimisation but without cmov,
some i386, some install i386 or i686, others optimise for newer
processors only and so on.

Alan
