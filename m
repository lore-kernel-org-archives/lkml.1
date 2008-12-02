Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbYLBRF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbYLBRF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 12:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754597AbYLBRFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 12:05:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754591AbYLBRFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 12:05:50 -0500
Date: Tue, 2 Dec 2008 09:05:12 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
cc: "Renato S. Yamane" <yamane@diamondcut.com.br>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: About git-bisect (was: Linux 2.6.28-rc7)
In-Reply-To: <20081202165557.GA10637@uranus.ravnborg.org>
Message-ID: <alpine.LFD.2.00.0812020901530.3256@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0812012004370.3256@nehalem.linux-foundation.org> <20081202131442.42e7df48@varda> <alpine.LFD.2.00.0812020748310.3256@nehalem.linux-foundation.org> <20081202165637.09984819@varda> <alpine.LFD.2.00.0812020804590.3256@nehalem.linux-foundation.org>
 <49356274.6080400@diamondcut.com.br> <20081202165557.GA10637@uranus.ravnborg.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Dec 2008, Sam Ravnborg wrote:
> 
> You do not need to do a "make clean" between each build, so if none
> of the core files are touched you should be much faster.

Not for big ranges, sadly.

Because "git bisect" tends to jump around wildly, it's very rare to not 
have to rebuild the whole tree. Only at the very last few bisection events 
(when it's been narrowed down to just a few tens of commits) will you 
generally see your compiles speed up.

That said, the _best_ way to speed up your compile (whether bisecting or 
not) is to simply only compile the drivers and modules you actually need. 
It takes me 16 seconds to compile my kernel (if it's all cached), and 
that's largely because I do _not_ compile one of the crazy distro kernels 
with thousands of totally irrelevant modules for my setup.

A good config file will not just result in a smaller kernel, it will often 
cut down your kernel compile times by a factor of ten or even more.

				Linus
