Return-Path: <linux-kernel-owner+w=401wt.eu-S1752822AbZKBAAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbZKBAAO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 19:00:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbZKBAAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 19:00:13 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56679 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752740AbZKBAAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 19:00:12 -0500
Date: Mon, 2 Nov 2009 00:01:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Ryan C. Gordon" <icculus@icculus.org>
Cc: =?ISO-8859-14?B?TeVucyBSdWxsZ+VyZA==?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: FatELF patches...
Message-ID: <20091102000147.424f104b@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.OSX.1.10.0911011540400.53392@caridad.local>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan>
	<1257103201.2865.6.camel@chumley>
	<yw1xy6mq0z2s.fsf@unicorn.mansr.com>
	<alpine.OSX.1.10.0911011540400.53392@caridad.local>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lets go down the list of "benefits"

- Separate downloads
	- Doesn't work. The network usage would increase dramatically
	  pulling all sorts of unneeded crap.
	- Already solved by having a packaging system (in fact FatELF is
	  basically obsoleted by packaging tools)

- Separate lib, lib32, lib64
	- So you have one file with 3 files in it rather than three files
	  with one file in them. Directories were invented for a reason
	- Makes updates bigger
	- Stops users only having 32bit libs for some packages

- Third party packagers no longer have to publish multiple rpm/deb etc
	- By vastly increasing download size
	- By making updates vastly bigger
	- Assumes data files are not dependant on binary (often not true)
	- And is irrelevant really because 90% or more of the cost is
	  testing

- You no longer need to use shell scripts and flakey logic to pick the
  right binary ...
	- Since the 1990s we've used package managers to do that instead.
	  I just type "yum install bzflag", the rest is done for me.

- The ELF OSABI for your system changes someday?
	- We already handle that

- Ship a single shared library that provides bindings for a scripting
  language and not have to worry about whether the scripting language
  itself is built for the same architecture as your bindings. 
	- Except if they don't overlap it won't run

- Ship web browser plugins that work out of the box with multiple
  platforms.
	- yum install just works, and there is a search path in firefox
	  etc

- Ship kernel drivers for multiple processors in one file.
	- Not useful see separate downloads

- Transition to a new architecture in incremental steps. 
	- IFF the CPU supports both old and new
	- and we can already do that

- Support 64-bit and 32-bit compatibility binaries in one file. 
	- Not useful as we've already seen

- No more ia32 compatibility libraries! Even if your distro
  doesn't make a complete set of FatELF binaries available, they can
  still provide it for the handful of packages you need for 99% of 32-bit
  apps you want to run on a 64-bit system. 

	- Argument against FatELF - why waste the disk space if its rare ?

- Have a CPU that can handle different byte orders? Ship one binary that
  satisfies all configurations!

	- Variant of the distribution "advantage" - same problem - its
	  better to have two files, its all about testing anyway

- Ship one file that works across Linux and FreeBSD (without a platform
  compatibility layer on either of them). 

	- Ditto

- One hard drive partition can be booted on different machines with
  different CPU architectures, for development and experimentation. Same
  root file system, different kernel and CPU architecture. 

	- Now we are getting desperate.

- Prepare your app on a USB stick for sneakernet, know it'll work on
  whatever Linux box you are likely to plug it into.

	- No I don't because of the dependancies, architecture ordering
	  of data files, lack of testing on each platform and the fact
	  architecture isn't sufficient to define a platform

- Prepare your app on a network share, know it will work with all
  the workstations on your LAN. 

	- Variant of the distribution idea, again better to have multiple
	  files for updating and management, need to deal with
	  dependancies etc. Waste of storage space.
	- We have search paths, multiple mount points etc.

So why exactly do we want FatELF. It was obsoleted in the early 1990s
when architecture handling was introduced into package managers.

