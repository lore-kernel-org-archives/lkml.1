Return-Path: <linux-kernel-owner+w=401wt.eu-S1764255AbZDIV5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764255AbZDIV5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 17:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759910AbZDIV4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 17:56:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759017AbZDIV4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 17:56:50 -0400
Date: Thu, 9 Apr 2009 14:52:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: bugzilla-daemon@bugzilla.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Barry K. Nathan" <barryn@pobox.com>, stable@kernel.org
Subject: Re: [Bugme-new] [Bug 13012] New: 2.6.28.9 causes init to segfault
 on Debian etch; 2.6.28.8 OK
In-Reply-To: <20090409143755.96e0c62c.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0904091440520.4583@localhost.localdomain>
References: <bug-13012-10286@http.bugzilla.kernel.org/> <20090409143755.96e0c62c.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 9 Apr 2009, Andrew Morton wrote:
> 
> -fwrapv killed Barry's gcc-4.1.2-compiled kernel in 2.6.27.x, 2.6.28.x
> and presumably 2.6.29, 2.6.30.

Auughh. I hate compiler bugs. They're horrible to debug.

I _think_ 'fwrapv' only really matters with gcc-4.3, so maybe we could 
just enable it for new versions.

HOWEVER, I also wonder if we could instead of "-fwrapv" use 
"-fno-strict-overflow". They are apparently subtly different, and maybe 
the bug literally only happens with -fwrapv.

Barry, can you see if that simple "replace -fwrapv with 
-fno-strict-overflow" works for you?

Or just go with Barry's helpful debugging:

> > I also noticed that the problem only happens with some gcc's:
> > 
> > Problem occurs:
> > gcc (GCC) 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)
> > gcc-4.1 (GCC) 4.1.3 20080704 (prerelease) (Debian 4.1.2-25)
> > 
> > Problem does not occur (i.e. 2.6.28.9 works and I don't have to revert
> > anything):
> > gcc-4.2 (GCC) 4.2.4 (Debian 4.2.4-6)
> > gcc (Debian 4.3.2-1.1) 4.3.2

and consider 4.2 to be the point where it's ok.

Do we have some gcc developer who 
 (a) knows what the rules are
and
 (b) might even help us figure out where the bug occurs?

		Linus
