Return-Path: <linux-kernel-owner+w=401wt.eu-S1761640AbXHaDuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761640AbXHaDuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 23:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbXHaDu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 23:50:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51195 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750958AbXHaDu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 23:50:26 -0400
Date: Thu, 30 Aug 2007 20:49:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Frank van Maarseveen <frankvm@frankvm.com>
cc: Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: recent nfs change causes autofs regression
In-Reply-To: <1188513433.6626.24.camel@heimdal.trondhjem.org>
Message-ID: <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org>
References: <000701c7eb49$cff701c0$6fe50540$@com>
 <1188513433.6626.24.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 30 Aug 2007, Trond Myklebust wrote:
> 
> Which is better than having it fail silently, or giving you a mount with
> the wrong mount options.

No, Trond.

That commit gets reverted or fixed. It's a regression, and your theories 
that it's "better" that way are obviously broken.

It's obviously broken because you seem to say that you know better, even 
though you also admit that:

  "How is the NFS client to know that these directories are disjoint, or
   that no-one will ever create a hard link from one directory to another? 
   To my knowledge, the only way to ensure this is to put them on 
   different disk partitions."

the point being that you just disallowed people from doing things that are 
sane but _potentially_ dangerous. That's now how we work. The UNIX way sis 
to give people rope - if you cannot *prove* that what they are doing is 
wrong, then you damn well better not disallow it.

No regressions, Trond. Especially not for stuff that used to work, was 
used, and that could be sanely expected to work (which this *definitely*
sounds like).

Please send in a fix. If the fix involves making "nosharecache" the 
default, then that is better than making policy decisions like this in the 
kernel. The kernel should do what the user asks and not put in unnecessary 
roadblocks.

Hua - that said, I don't actually see why the commit you bisected to has 
anything to do with the issue being discussed. Can you double-check that 
it's literally that particular commit that breaks for you (you could try 
just reverting that commit).

			Linus
