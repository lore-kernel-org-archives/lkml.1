Return-Path: <linux-kernel-owner+w=401wt.eu-S1750760AbXBMPvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750760AbXBMPvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 10:51:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbXBMPvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 10:51:41 -0500
Received: from smtp.osdl.org ([65.172.181.24]:41813 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbXBMPvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 10:51:40 -0500
Date: Tue, 13 Feb 2007 07:51:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Verych <olecom@flower.upol.cz>
cc: Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Roman Zippel <zippel@linux-m68k.org>,
       Bastian Blank <bastian@waldi.eu.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch 3/3, resend] kbuild: correctly skip tilded backups in
 localversion files
In-Reply-To: <20070213050503.GA27441@flower.upol.cz>
Message-ID: <Pine.LNX.4.64.0702130744030.8424@woody.linux-foundation.org>
References: <20070206011819.160359000@flower.upol.cz> <20070206012208.050237000@flower.upol.cz>
 <12c511ca0702121409t30e126dfh445d13dd2f637e08@mail.gmail.com>
 <Pine.LNX.4.64.0702121437420.8424@woody.linux-foundation.org>
 <20070213003258.GA15534@flower.upol.cz> <20070213050503.GA27441@flower.upol.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Feb 2007, Oleg Verych wrote:
> 
> I mean, all by-hand modifications must be in the $(srctree) (let's get
> this term), $(objtree) is output *only*.

No. Especially for things like localversion, the object tree (if it is 
different) is very much where you'd put that marker.

You might have several object trees for the same source tree, with 
different configurations. Exactly to remember which one is which, you'd 
have a "localversion" file in each object tree.

> I know it maybe another my "change it all" proposition, but i can't find
> nothing against `GNU $(wildcard ..)' and `unnecessarily complex "find"'.

It's the regexp in both cases. $(wildcard ) doesn't do regexp's (only the 
normal path rules), and traditional 'find' doesn't either. The fact that 
GNU find does is another matter. I don't think we require GNU find 
normally.

And I don't even much like the "backup" thing. Some programs will use 
other things than "~" as a backup marker. Patch more often uses ".orig", 
for example. So both methods are fairly complex, but at the same time not 
quite complex enough.

It would probably have been a better idea had we made the rule be that the 
file is called "*localversion" rather than "localversion*", exactly 
because that way it's unambiguous (people normally use _suffixes_ for 
filetypes, not prefixes). That would have avoided the whole complexity in 
wildcarding, but it's too late now..

	$(sort $(wildcard $(srctree)/*localversion $(objtree)/*localversion)

should have worked.

		Linus
