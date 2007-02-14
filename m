Return-Path: <linux-kernel-owner+w=401wt.eu-S932167AbXBNBI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167AbXBNBI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 20:08:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932212AbXBNBI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 20:08:26 -0500
Received: from raven.upol.cz ([158.194.120.4]:45271 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932167AbXBNBIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 20:08:25 -0500
Date: Wed, 14 Feb 2007 02:16:44 +0100
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Bastian Blank <bastian@waldi.eu.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: kbuild, localversion (Re: [patch 3/3, resend] kbuild: correctly skip tilded backups in localversion files)
Message-ID: <20070214011644.GA13502@flower.upol.cz>
References: <20070206011819.160359000@flower.upol.cz> <20070206012208.050237000@flower.upol.cz> <12c511ca0702121409t30e126dfh445d13dd2f637e08@mail.gmail.com> <Pine.LNX.4.64.0702121437420.8424@woody.linux-foundation.org> <20070213003258.GA15534@flower.upol.cz> <20070213050503.GA27441@flower.upol.cz> <Pine.LNX.4.64.0702130744030.8424@woody.linux-foundation.org> <Pine.LNX.4.64.0702131700190.14457@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702131700190.14457@scrub.home>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo!

On Tue, Feb 13, 2007 at 05:09:47PM +0100, Roman Zippel wrote:
> Hi,
> 
> On Tue, 13 Feb 2007, Linus Torvalds wrote:
> 
> > > I know it maybe another my "change it all" proposition, but i can't find
> > > nothing against `GNU $(wildcard ..)' and `unnecessarily complex "find"'.
> > 
> > It's the regexp in both cases. $(wildcard ) doesn't do regexp's (only the 
> > normal path rules), and traditional 'find' doesn't either. The fact that 
> > GNU find does is another matter. I don't think we require GNU find 
> > normally.
> > 
> > And I don't even much like the "backup" thing. Some programs will use 
> > other things than "~" as a backup marker. Patch more often uses ".orig", 
> > for example. So both methods are fairly complex, but at the same time not 
> > quite complex enough.
> > 
> > It would probably have been a better idea had we made the rule be that the 
> > file is called "*localversion" rather than "localversion*", exactly 
> > because that way it's unambiguous (people normally use _suffixes_ for 
> > filetypes, not prefixes). That would have avoided the whole complexity in 
> > wildcarding, but it's too late now..
> > 
> > 	$(sort $(wildcard $(srctree)/*localversion $(objtree)/*localversion)
> > 
> > should have worked.

As part of my personal preparation for "a new kind of things" i
finally went to the same idea with suffixes.

What i currently have is:

-- top file 'Linux.version', with first line:

3.0.0-rcX
which can be parsed to fill variables, used in build process (how many
`.' and/or `-' in it -- doesn't really matter), second line is the name;

-- 'MM.version' for MM tree;

-- '[a-z]*\.version' for anything else.

usual sort will place files in right order.

> For now I think it's easier to just revert the change to use find, I 
> posted the patch for this already a few days ago.
> I don't know if it really makes sense to change the rules for this now, 
> apparently people are using this, it may not be perfect, but I think in 
> the end it's just a matter of taste.

At least we have some discussion. Unless Linus use `sed' for patching
Makefile for versions, i think, to edit one or two lines in 50kB monster,
isn't so much pleasure ;)

____
