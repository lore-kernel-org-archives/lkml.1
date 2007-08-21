Return-Path: <linux-kernel-owner+w=401wt.eu-S1753412AbXHUEQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbXHUEQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 00:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbXHUEQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 00:16:30 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47153 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750808AbXHUEQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 00:16:29 -0400
Date: Mon, 20 Aug 2007 21:15:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Stuart_Hayes@Dell.com" <Stuart_Hayes@dell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Exner <dex@dragonslave.de>
Subject: Re: [linux-usb-devel] [4/4] 2.6.23-rc3: known regressions
In-Reply-To: <200708202102.58508.david-b@pacbell.net>
Message-ID: <alpine.LFD.0.999.0708202106290.30176@woody.linux-foundation.org>
References: <46C098FD.1030601@googlemail.com> <200708201841.51366.david-b@pacbell.net>
 <alpine.LFD.0.999.0708201853020.30176@woody.linux-foundation.org>
 <200708202102.58508.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 20 Aug 2007, David Brownell wrote:
> 
> MMF basically means the "Transaction Translating" (TT) hub had data
> for the host, but the host didn't collect it in time ... so that some
> data was lost.
> 
> Unfortunately, that's the type of fault that's especially hard to
> recover from.

Fair enough. However, it still seems particularly idiotic to
 - penalize everybody
 - mix up two totally unrelated areas (cpufreq and USB) for a bug that is 
   extremely rare and could be handled differently.

For example, if it really ends up being practically impossible to recover 
from split transaction errors, I would still suggest reverting that horrid 
commit, and then just black-listing the known-broken EHCI controllers and 
simply not *do* any split transactions on them. That way there's no 
complexity.

As far as I know, split transactions aren't required anyway, they are just 
a performance optimization.

Basically, we not only know that the commit has caused problems, it's 
fundamentally ugly, fragile, and not very maintainable, and the whole 
reason for doing it is pretty dubious.

Why not just admit that certain hardware is broken (and the vendor isn't 
worth even bothering to be polite with, since they try to screw us every 
chance they get) and cannot reliably do split transactions? Problem 
solved, no real downside, and nobody will even *notice*.

			Linus
