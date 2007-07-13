Return-Path: <linux-kernel-owner+w=401wt.eu-S934199AbXGMGfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934199AbXGMGfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 02:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbXGMGfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 02:35:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57119 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752086AbXGMGfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 02:35:08 -0400
Date: Thu, 12 Jul 2007 23:34:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bryan Wu <bryan.wu@analog.com>
cc: Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       Nish Aravamudan <nish.aravamudan@gmail.com>
Subject: Re: Linux 2.6.22.1
In-Reply-To: <1184308100.8943.12.camel@roc-desktop>
Message-ID: <alpine.LFD.0.999.0707122328340.20061@woody.linux-foundation.org>
References: <29495f1d0707121135u2a07cf04nb8bfe555c5c63679@mail.gmail.com> 
 <1184307380.8943.7.camel@roc-desktop>  <20070713061617.GA24317@kroah.com>
 <1184308100.8943.12.camel@roc-desktop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 13 Jul 2007, Bryan Wu wrote:
> 
> I can git-pull from Linus tree through http in my company, this one
> can't. If it is not easy to open it by you guys, I have to git-pull at
> home, -:))

In that case, it's almost certainly that that tree isn't doing the proper 
"git update-server-info" when people push to it.

Chris/Greg: just add a

	hooks/post-update

file to your git repo that is executable, and just contains

	#!/bin/sh
	exec git-update-server-info

in it, and you'll be golden. It will mean that every time you push to the 
repo, it will run the "git update-server-info" thing after the push. And 
that will update all the necessary files for the stupid protocols (ie 
http) that don't know about git natively.

Oh, and run the "git-update-server-info" once by hand, just so that you 
don't then have to wait until after the next push for the git repo to be 
accessible by http://

www.kernel.org serves git repos fine, but the git repos have to help a bit 
at doing so.

What git update-server-info does is to create "info/refs" and 
"objects/info/packs" files that contain enough information for a client to 
figure out what refs and pack objects exist, so that they can try to fetch 
the necessary data on their own.

		Linus
