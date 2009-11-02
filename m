Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbZKBPON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbZKBPON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 10:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbZKBPON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 10:14:13 -0500
Received: from icculus.org ([67.106.77.212]:40528 "EHLO icculus.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256AbZKBPON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 10:14:13 -0500
Date: Mon, 2 Nov 2009 10:14:15 -0500 (EST)
From: "Ryan C. Gordon" <icculus@icculus.org>
X-X-Sender: icculus@caridad.icculuslan
To: Valdis.Kletnieks@vt.edu
cc: =?ISO-8859-15?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: FatELF patches...
In-Reply-To: <63587.1257137919@turing-police.cc.vt.edu>
Message-ID: <alpine.OSX.1.10.0911020012500.56087@caridad.local>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan> <1257103201.2865.6.camel@chumley> <yw1xy6mq0z2s.fsf@unicorn.mansr.com> <alpine.OSX.1.10.0911011540400.53392@caridad.local> <yw1xhbte0wx0.fsf@unicorn.mansr.com>           
 <alpine.OSX.1.10.0911011623070.55174@caridad.local> <63587.1257137919@turing-police.cc.vt.edu>
User-Agent: Alpine 1.10 (OSX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > think if Ubuntu did this as a distribution-wide policy, then people would 
> > probably choose a different distribution.
> 
> Hmm.. so let's see - people compiling stuff for themselves won't use this
> feature.  And if a distro uses it, users would probably go to a different
> distro.

I probably wasn't clear when I said "distribution-wide policy" followed by 
a "then again." I meant there would be backlash if the distribution glued 
the whole system together, instead of just binaries that made sense to do 
it to.

And, again, there's a third use-case besides compiling your programs and 
getting them from the package manager, and FatELF is meant to address 
that.

> Actually, they can't nuke the /lib{32,64} directories unless *all* binaries
> are using FatELF - as long as there's any binaries doing things The Old Way,
> you need to keep the supporting binaries around.

Binaries don't refer directly to /libXX, they count on ld.so to tapdance 
on their behalf. My virtual machine example left the dirs there as 
symlinks to /lib, but they could probably just go away directly.

> Don't forget you take that hit once for each shared library involved.  Plus

That happens in user space in ld.so, so it's not a kernel problem in any 
case, but still...we're talking about, what? Twenty more branch 
instructions per-process?

> I'm not sure if there's hidden gotchas lurking in there (is there code that
> assumes that if executable code is mmap'ed, it's only done so in one arch?

The current code sets up file mappings based on the offset of the desired 
ELF binary.

> Or will a FatELF glibc.so screw up somebody's refcounts if it's mapped
> in both 32 and 64 bit modes?

Whose refcounts would this screw up? If there's a possible bug, I'd like 
to make sure it gets resolved, of course.

--ryan.

