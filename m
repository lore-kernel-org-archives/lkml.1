Return-Path: <linux-kernel-owner+w=401wt.eu-S1751858AbZKDSql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbZKDSql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 13:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750752AbZKDSqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 13:46:40 -0500
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:54058 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbZKDSqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 13:46:40 -0500
Date: Wed, 4 Nov 2009 19:46:44 +0100 (CET)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Martin Nybo Andersen <tweek@tweek.dk>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Ryan C. Gordon" <icculus@icculus.org>,
       =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: package managers [was: FatELF patches...]
In-Reply-To: <200911041848.48721.tweek@tweek.dk>
Message-ID: <Pine.LNX.4.64.0911041901090.26209@artax.karlin.mff.cuni.cz>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan>
 <20091104165407.1481bc29@lxorguk.ukuu.org.uk>
 <Pine.LNX.4.64.0911041758420.9986@artax.karlin.mff.cuni.cz>
 <200911041848.48721.tweek@tweek.dk>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > You can say that I should delete RHEL-5 and install Fedora, but that is
> > just that "upgrade one program" => "upgrade all programs" problem.
> 
> Have you ever tried upgrading Windows because some program is incompatible 
> with the current installation? ... That is indeed an 'upgrade all' procedure 
> ... _If_ you're lucky enough to be able to reinstall your software.

Some Windows programs force upgrade, but not in yearly cycles, like Linux 
programs. Majority of programs still work on XP shipped in 2001.

> Being able to upgrade at least Debian -- and others as well -- without the 
> need to attend the computer is IMHO one of Linux' biggest wins.

When I did it (from Etch to Lenny), two programs that I have compiled 
manually ("vim" and "links") stopped working because Etch and Lenny have 
binary-incompatible libgpm.

If some library cannot keep binary compatibility, it should be linked 
staticaly, dynamic version shouldn't even exists on the system --- so that 
no one can create incompatible binaries.

> BTW: Wine has, like many others, the newest version of their software 
> prepackaged for RHEL 4 & 5 among others at their site: 
> http://www.winehq.org/download/

This is exactly the link that I followed and the last version for "RHEL 5" 
is "wine-1.0.1-1.el5.i386.rpm".

> If all else fail the developers could go for statically compiled binaries in 
> an executable tarball, which then handles the installation to /usr/local
> 
> -Martin

Static linking doesn't work for any program that needs plug-ins (i.e. 
you'd have one glibc statically linked into the program and another glibc 
dynamically linked with a plug-in and these two glibcs will beat each 
other).

---

I mean this --- the distributions should agree on a common set of 
libraries and their versions (call this for example "Linux-2010 
standard"). This standard should include libraries that are used 
frequently, that have low occurence of bugs and security holes and that 
have never had an ABI change.

A distribution that claims compatibility with the standard must ship 
libraries that are compatible with the libraries in the standard (not 
necessarily the same version, it may ship higher version for security or 
so).

Software developers that claim compatibility with the standard will link 
standard libraries dynamically and must use static linking for all 
libraries not included in the standard. Or they can use dynamic linking 
and ship the non-standard library with the application in its private 
directory (so that nothing but that application links against it).

Then, software developers could make a release for "Linux-2010" and it 
would work on all distributions.

You'd no longer need a [ distributions X programs ] matrix of binaries 
and packages.

In five years, you could revisit the standard to "Linux-2015" with newer 
versions of libraries and force the users only to five-years upgrades, not 
yearly upgrades as it is now. "Linux-2015" should be backward compatible 
with "Linux-2010", so an user doing upgrade would only need to overwrite 
his /lib and /usr/lib, he woudn't even need to change the programs.

Mikulas
