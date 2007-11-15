Return-Path: <linux-kernel-owner+w=401wt.eu-S1753314AbXKOFga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbXKOFga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 00:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751093AbXKOFgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 00:36:22 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36603 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751074AbXKOFgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 00:36:21 -0500
Date: Wed, 14 Nov 2007 21:35:53 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bron Gondwana <brong@fastmail.fm>
cc: Christian Kujau <lists@nerdbynature.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] New Kernel Bugs
In-Reply-To: <20071115052538.GA21522@brong.net>
Message-ID: <alpine.LFD.0.9999.0711142130090.2786@woody.linux-foundation.org>
References: <20071113034916.2556edd7.akpm@linux-foundation.org> <20071113.035824.40509981.davem@davemloft.net> <20071113041259.79c9a8c5.akpm@linux-foundation.org> <20071113.043207.44732743.davem@davemloft.net> <20071113110259.44c56d42.akpm@linux-foundation.org>
 <alpine.DEB.0.9999.0711132055550.7865@sheep.housecafe.de> <20071113130411.26ccae12.akpm@linux-foundation.org> <alpine.DEB.0.99999.0711132239350.3960@sheep.housecafe.de> <20071115040708.GB15302@brong.net> <alpine.LFD.0.9999.0711142020220.2786@woody.linux-foundation.org>
 <20071115052538.GA21522@brong.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Nov 2007, Bron Gondwana wrote:
> 
> So we've already been running those settings for a while.  They didn't
> help.

Ok, so something else is up. If the mmap file is 2G, and you have 6G of 
RAM, you shouldn't be hitting the dirty limits with those setups.

Of course, it may still be that some accounting thing is simply off, and 
the dirty limits trigger *despite* all the proper config settings ;)

> Guess we'd better get on to figuring building a simple test app.

Yeah, if you have something that others can see in action, that is sure 
going to get more people to look at it. 

That said - I'm sincerely hoping that you're not running on a 32-bit 
kernel. Because if so, those percentages are percentages of *normal* 
memory, not highmem (that got changed at one point after people ran out of 
lowmem).

So even at 100% dirty limits, it won't let you dirty more than 1GB on the 
default 32-bit setup.

		Linus
