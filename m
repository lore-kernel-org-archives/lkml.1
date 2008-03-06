Return-Path: <linux-kernel-owner+w=401wt.eu-S1761572AbYCFMDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761572AbYCFMDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 07:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbYCFMDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 07:03:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbYCFMDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 07:03:42 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: Jan Beulich <jbeulich@novell.com>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix typo(?) in step.c
In-Reply-To: Ingo Molnar's message of  Thursday, 6 March 2008 12:28:19 +0100 <20080306112819.GC17906@elte.hu>
References: <47CE69B0.76E4.0078.0@novell.com>
	<20080305134150.GA16477@elte.hu>
	<20080306075223.BA28B2700FD@magilla.localdomain>
	<20080306112819.GC17906@elte.hu>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20080306120309.E4BE52700FD@magilla.localdomain>
Date: Thu,  6 Mar 2008 04:03:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * Roland McGrath <roland@redhat.com> wrote:
> 
> > The bogon came in commit eee3af4a2c83a97fff107ddc445d9df6fded9ce4, the 
> > introduction of the ptrace BTS stuff.  Sorry I did not scour and cite 
> > every problem in that patch, since I had NAK'd the entire thing as 
> > needing more careful review and incremental introduction after 2.6.25.
> 
> note that in -rc4 all those BTS ptrace extensions are disabled, see:

I know.  That completely misses the point I just made:

   As I said then, one of my concerns was with the low-level tweaks not yet
   sufficiently baked, independent from my reservations about the ptrace
   feature.  Your #if'ing out of the user ABI additions for 2.6.25 does
   nothing to remove the unknown new risks from all the tweaks with fingers in
   the low-level arch stuff.  This is the sort of thing I was concerned about.

You didn't revert the parts that ever could have caused problems for anyone
except those using the new ptrace extensions, i.e. changes to step.c,
context switch, whatever else was touched we've lost track of now.  I keep
saying that those are not baked, 100% independent of the ptrace feature.  
You don't seem to be hearing me.


Thanks,
Roland
