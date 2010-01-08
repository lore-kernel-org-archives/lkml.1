Return-Path: <linux-kernel-owner+w=401wt.eu-S1751667Ab0AHBa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667Ab0AHBa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 20:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750870Ab0AHBa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 20:30:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45733 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750781Ab0AHBa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 20:30:56 -0500
Date: Thu, 7 Jan 2010 17:30:50 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Trond Myklebust <Trond.Myklebust@netapp.com>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Please pull NFS client bugfixes....
In-Reply-To: <1262913752.2659.100.camel@localhost>
Message-ID: <alpine.LFD.2.00.1001071727490.7821@localhost.localdomain>
References: <1262896174.2659.3.camel@localhost>  <87zl4pmxzp.fsf@basil.nowhere.org> <1262901198.2659.38.camel@localhost>  <20100107235149.GD16076@basil.fritz.box>  <1262909682.2659.45.camel@localhost>  <alpine.LFD.2.00.1001071633200.7821@localhost.localdomain>
  <1262912601.2659.89.camel@localhost>  <alpine.LFD.2.00.1001071707430.7821@localhost.localdomain> <1262913752.2659.100.camel@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Jan 2010, Trond Myklebust wrote:
> 
> I don't think anyone has been advocating doing the revalidation _after_
> the call to mmap_region(). All I want is to be able to do it as part of
> the mmap() syscall. It would be quite OK to add a ->pre_mmap() (which is
> what I believe Peter's patches do).

->pre_mmap is better, but not obviously so. We'd have to call ->pre_mmap() 
so _long_ before the mmap that it might be that the mmap never happens at 
all (due to errors happening later). 

Sounds like that would work in your particular case, though.

However, I still suspect that the lock inversion problem can probably be 
fixed without any of that at all. Maybe you can just break the chain 
somewhere else. I've not actually seen the lockdep chain, so I don't know 
the deails. Pointers?

		Linus
