Return-Path: <linux-kernel-owner+w=401wt.eu-S933876AbXCFCyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933876AbXCFCyi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 21:54:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933882AbXCFCyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 21:54:38 -0500
Received: from smtp.osdl.org ([65.172.181.24]:48269 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933876AbXCFCyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 21:54:37 -0500
Date: Mon, 5 Mar 2007 18:54:25 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ed Tomlinson <edt@aei.ca>
cc: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Revell <rlrevell@joe-job.com>,
       Nicolas Mailhot <nicolas.mailhot@laposte.net>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu
 scheduler
In-Reply-To: <200703052123.29421.edt@aei.ca>
Message-ID: <Pine.LNX.4.64.0703051849410.3998@woody.linux-foundation.org>
References: <54348.192.54.193.51.1173087934.squirrel@rousalka.dyndns.org>
 <75b66ecd0703051020h1f0c1f85r15a5de082a80cec0@mail.gmail.com>
 <200703051419.25814.gene.heskett@gmail.com> <200703052123.29421.edt@aei.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Mar 2007, Ed Tomlinson wrote:
> 
> The patch _does_ make a difference.  For instance reading mail with freenet working 
> hard  (threaded java application) and gentoo's emerge triggering compiles to update the 
> box is much smoother.
> 
> Think this scheduler needs serious looking at.  

I agree, partly because it's obviously been getting rave reviews so far, 
but mainly because it looks like you can think about behaviour a lot 
better, something that was always very hard with the interactivity 
boosters with process state history.

I'm not at all opposed to this, but we do need:
 - to not do it at this stage in the stable kernel
 - to let it sit in -mm for at least a short while
 - and generally more people testing more loads.

I don't actually worry too much about switching out a CPU scheduler: those 
things are places where you *can* largely read the source code and get an 
idea for them (although with the kind of history state that we currently 
have, it's really really hard). But at the very least they aren't likely 
to have subtle bugs that show up elsewhere, so...

So as long as the generic concerns above are under control, I'll happily 
try something like this if it can be merged early in a merge window..

			Linus
