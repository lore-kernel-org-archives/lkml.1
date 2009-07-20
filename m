Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbZGTTuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbZGTTuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 15:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbZGTTuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 15:50:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35398 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751555AbZGTTux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 15:50:53 -0400
Date: Mon, 20 Jul 2009 12:50:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Kiko Piris <kernel@pirispons.net>
cc: Damien Wyart <damien.wyart@free.fr>, Greg KH <gregkh@suse.de>,
       Wolfgang Walter <wolfgang.walter@stwm.de>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.30.2: does not boot
In-Reply-To: <20090720192933.GA22641@superlopez.pirispons.net>
Message-ID: <alpine.LFD.2.01.0907201241490.19335@localhost.localdomain>
References: <20090720040813.GC11940@kroah.com> <200907201613.22483.wolfgang.walter@stwm.de> <20090720150916.GB10015@suse.de> <20090720180333.GA2905@brouette> <20090720192933.GA22641@superlopez.pirispons.net>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 20 Jul 2009, Kiko Piris wrote:
> 
> On 20/07/2009 at 20:03 +0200, Damien Wyart wrote:
> 
> > I am seeing a similar problem (no hang but an immediate reboot) on the
> > same distro.
> 
> Exactly the same than me.
> 
> > I suspected a recent gcc 4.3 upgrade so downgraded gcc, but no luck,
> > still getting the same problem.  So for now I am quite stuck, but
> > there is clearly a bad problem somewhere...
> 
> I compiled 2.6.30.1 some days ago:
> 
> | $ uname -a
> | Linux rompetechos 2.6.30.1 #1 SMP Fri Jul 3 16:11:06 CEST 2009 i686 GNU/Linux

Just to clarify:

 - you literally have a _working_ 2.6.30.1 that you compiled yourself a 
   few days ago.

 - But when you try to compile that same kernel _now_, it fails with an 
   immediate reboot? And not just 2.6.30.2, but 2.6.30.1 does that too?

That certainly implies something else than just the -fwrapv vs 
-fno-strict-overflow thing.

But we may be looking at two different issues, so maybe your "unable to 
compile a working kernel" issue is different from the other reports.

So can anybody confirm that they can really compile (on the same machine, 
with the same compiler and libc, right after each other) 2.6.30.1 and it 
works, but 2.6.30.2 does not work?

And in particular, if you can do that, it would be really interesting to 
see your 'vmlinux' file with -fno-strict-overflow, and then the exact same 
compile but with the top-level Makefile changed to use -fwrapv instead 
(and please double-check that the -fwrapv kernel works, and the 
-fno-strict-overflow)

Sadly, the code generation differences you get between -fwrapv and 
-fno-strict-overflow are not trivial to sort out (I just tested it on my 
own kernel - obviously working in both cases), but I'd be willing to try. 
If somebody can really guarantee that the _only_ thing that changed was 
that one compiler flag (rather than a gcc/glibc update or anything else, 
which seems to be implicated here for some people).

		Linus
