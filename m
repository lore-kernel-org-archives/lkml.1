Return-Path: <linux-kernel-owner+w=401wt.eu-S932742AbZKDXzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932742AbZKDXzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 18:55:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758225AbZKDXzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 18:55:49 -0500
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:60886 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758018AbZKDXzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 18:55:48 -0500
Date: Thu, 5 Nov 2009 00:55:53 +0100 (CET)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Martin Nybo Andersen <tweek@tweek.dk>
cc: kevin granade <kevin.granade@gmail.com>, Valdis.Kletnieks@vt.edu,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Ryan C. Gordon" <icculus@icculus.org>,
       =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: package managers [was: FatELF patches...]
In-Reply-To: <200911042343.01957.tweek@tweek.dk>
Message-ID: <Pine.LNX.4.64.0911050019540.1469@artax.karlin.mff.cuni.cz>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan>
 <7004b08e0911041332x259c02afg612be7eb02e4d6bb@mail.gmail.com>
 <Pine.LNX.4.64.0911042244030.24799@artax.karlin.mff.cuni.cz>
 <200911042343.01957.tweek@tweek.dk>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Windows, the user can just download the EXE, run it, click
> > next-next-next-finish and have it installed. There is no package
> > management that would try to overwrite what you have just installed.
> 
> Exactly. There is nothing to help you from installing incompatible software 
> (ie libraries). If your next-next-next-finish installer overwrites a crucial 
> library, you're screwed. The package manager, on the other hand, knows about 
> all your installed files and their dependencies and conflicts.

The package manager can make the system unbootable too --- because of bugs 
in it or in packages.

In some situations, the package manager is even more dangerous than manual 
install. For example, if you are manually installing new alpha-quality 
version of mplayer, and it is buggy, you end up with a working system with 
broken mplayer. If you install alpha-quality version from some package 
repository, it may need experimental version of libfoo, that needs 
experimental version of libfee, that needs experimental version of glibc, 
that contains a bug --- and you won't boot (are rescue CDs smart enough to 
revert that upgrade?)

> If you really want to fiddle with your own software versions, 
> dependencies, and conflicts, then the equivs package is a perfect 
> helper, which lets you create virtual Debian packages (empty packages 
> with dependencies and such). For instance, I compile mplayer directly 
> from the subversion repository - however I still have some packages 
> installed, which depends on mplayer. Here the virtual mplayer package 
> keeps apt and friends from complaining.

Nice description ... the problem is that for desktop users it is still too 
complicated task.

I think the ultimate installer should work somehow like:
- extract the configure file from the *.tar.gz package.
- parse the options from configure (or configure.in/.ac) and present them 
to the user as checkboxes / input fields.
- let him click through the options with next-next-next-finish buttons :)
- try to run configure with user's options.
- if it fails, try to parse its output and install missing dependencies. 
This can't work in 100% cases, but it can work in >90% cases --- if we 
fail to parse the output, present it to the user and let him act on it.
- compile the program on background. (or foreground for geeks :)
- run "make install" it into a temporary directory.
- record what it tried to install (for possible undo) and then copy the 
files to the real places.

At least this would allow Linux users to use a lot available free software 
without relying on what the distribution does or doesn't pack. The user 
would work just like in Windows, download the program from developer's 
webpage and install it. He could upgrade or downgrade to any available 
versions released by the developer.

Mikulas
