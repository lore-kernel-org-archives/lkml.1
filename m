Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439Ab0CAQYG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 11:24:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750998Ab0CAQYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 11:24:03 -0500
Date: Mon, 1 Mar 2010 08:22:15 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, zippel@linux-m68k.org, mingo@elte.hu,
       akpm@linux-foundation.org
Subject: Re: [PATCH RFC] kconfig: place git SHA1 in .config output if in git
 tree
In-Reply-To: <20100301042249.GA12289@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.00.1003010812410.3616@localhost.localdomain>
References: <20100301042249.GA12289@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 28 Feb 2010, Paul E. McKenney wrote:
>
> Uses "git log" to print the hash.

Please don't use "git log" for something like this.

Sure, it works, but it's kind of silly to say "I want a log, except I want 
only a single entry, and btw, I don't actually even want the log entry for 
that single entry at all, just the hash".

It boils down to "I want a log, except with none of the log part". It 
should make you go "Do I really want a log"?

If you really want the hash, maybe just using "git rev-parse HEAD" would 
do it.

However, in this case I think _any_ of those would be wrong. Wouldn't it 
make sense to use the same thing that we already compute for 'uname' 
(scripts/setlocalversion)? Especially as that one already knows how to 
handle other SCM's too (ie the whole hg/svn parts).

That script also ends up using a nicer format, ie it uses "git describe" 
to give a better idea of where it all is.

				Linus
