Return-Path: <linux-kernel-owner+w=401wt.eu-S1752001Ab0AHBfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab0AHBfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 20:35:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422Ab0AHBfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 20:35:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56434 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379Ab0AHBfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 20:35:20 -0500
Date: Thu, 7 Jan 2010 17:35:14 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Trond Myklebust <Trond.Myklebust@netapp.com>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Please pull NFS client bugfixes....
In-Reply-To: <alpine.LFD.2.00.1001071727490.7821@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1001071731440.7821@localhost.localdomain>
References: <1262896174.2659.3.camel@localhost>  <87zl4pmxzp.fsf@basil.nowhere.org> <1262901198.2659.38.camel@localhost>  <20100107235149.GD16076@basil.fritz.box>  <1262909682.2659.45.camel@localhost>  <alpine.LFD.2.00.1001071633200.7821@localhost.localdomain>
  <1262912601.2659.89.camel@localhost>  <alpine.LFD.2.00.1001071707430.7821@localhost.localdomain> <1262913752.2659.100.camel@localhost> <alpine.LFD.2.00.1001071727490.7821@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Jan 2010, Linus Torvalds wrote:
> 
> However, I still suspect that the lock inversion problem can probably be 
> fixed without any of that at all. Maybe you can just break the chain 
> somewhere else. I've not actually seen the lockdep chain, so I don't know 
> the deails. Pointers?

For example, if we're talking about readdir having a lock the other way 
(NFS lock taken before the mmap_sem), it's entirely possible that there is 
nothing to "fix" but some lockdep annotation.

You cannot mmap a directory (and you can't readdir a non-directory), so if 
it's a per-inode NFS lock, then the simplest fix _might_ be to just put 
directory locks in a different lockdep class from non-directory locks. 
That might fix it.

Of course, if it's not a per-inode lock, that doesn't help.

And maybe I'm missing something entirely, and such games with lockdep 
classes are pointless, and I'm a moron. Quite possible.

		Linus
