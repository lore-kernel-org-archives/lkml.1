Return-Path: <linux-kernel-owner+w=401wt.eu-S1030578AbXBMAYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030578AbXBMAYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 19:24:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030582AbXBMAYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 19:24:10 -0500
Received: from raven.upol.cz ([158.194.120.4]:40666 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030578AbXBMAYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 19:24:08 -0500
Date: Tue, 13 Feb 2007 01:32:58 +0100
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Roman Zippel <zippel@linux-m68k.org>,
       Bastian Blank <bastian@waldi.eu.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch 3/3, resend] kbuild: correctly skip tilded backups in localversion files
Message-ID: <20070213003258.GA15534@flower.upol.cz>
References: <20070206011819.160359000@flower.upol.cz> <20070206012208.050237000@flower.upol.cz> <12c511ca0702121409t30e126dfh445d13dd2f637e08@mail.gmail.com> <Pine.LNX.4.64.0702121437420.8424@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702121437420.8424@woody.linux-foundation.org>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 02:53:29PM -0800, Linus Torvalds wrote:

Hallo.

> On Mon, 12 Feb 2007, Tony Luck wrote:
> > 
> > Git bisect fingers this patch (which is in Linus' tree as commit
> > 76c329563c5b8663ef27eb1bd195885ab826cbd0) as the culprit
> > for double adding the contents of the localversion file.  E.g.
> > 
> > $ echo -tiger-smp > localversion
> > $ make prepare
> > $ make kernelrelease
> > 2.6.20-tiger-smp-tiger-smp
> 
> Heh. It's because we search for the localversion files in both $objtree 
> and $srctree, and normally they are one and the same - so it finds the 
> same file twice.
> 
> The old code did the same thing, but with the "make" $(sort ..) function, 
> which apparently removes duplicates. We should use "sort -u" here.

Heh. Why one ever going to bloat $(srctree) to add more "dontdiff" and
such, where build is supporting dirty output?

While this is my mis-tesing,

> Both the old code *and* the new code is just horribly complex. The old 
> code appears to suffer from GNU $(wildcard ..), the new code is almost as 
> ugly in doing an unnecessarily complex "find".

any reasons to have multiple files for localversion(s), in $(objtree)
also? Exept one, that somebody used to use it, mm-tree doesn't btw.

As i opposed to Romans's "make" solution, because it wasn't obvious, i
agree current has heavy `find', but what else you can propose? I think,
it's not make's job after all.

> Oh well.

Thanks for testing!
____
