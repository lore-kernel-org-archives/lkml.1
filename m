Return-Path: <linux-kernel-owner+w=401wt.eu-S1762009AbXEWG6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762009AbXEWG6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 02:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756767AbXEWG6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 02:58:42 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:48211
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630AbXEWG6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 02:58:41 -0400
From: Rob Landley <rob@landley.net>
To: Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] Re: Cleaning up the Documentation directory.
Date: Wed, 23 May 2007 02:58:28 -0400
User-Agent: KMail/1.9.1
Cc: Roland Dreier <rdreier@cisco.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <200705222225.39949.rob@landley.net> <200705230025.45007.rob@landley.net> <20070523045606.GA28924@linux-sh.org>
In-Reply-To: <20070523045606.GA28924@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705230258.28777.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 May 2007 12:56 am, Paul Mundt wrote:
> On Wed, May 23, 2007 at 12:25:44AM -0400, Rob Landley wrote:
> >    mv arm cris blackfin parisc powerpc s390 x86_64 uml arch
> 
> You missed sh, mips, fujitsu/frv, m68k, ia64, i386, and sparc.

Yup.  I'll add 'em to the next pass.  Thanks.

There's plenty more to do.  (Why is smart-config.txt not in kbuild?  Why is 
rpc-cache.txt not in filesystems with nfs?  Why is xterm-linux.xpm in there 
at all, it's a graphic, not documentation...)  This was just me trying to 
figure out how to move files without big add/remove patches.  (I'd never set 
up git before, I use mercurial.)  A small and hopefully non-controversial 
set.

I'm trying to do a web version of the Documentation directory.  I've been 
reading through this on and off for a month now and I'm still trying to 
figure out where everything is.  The top level directory mixes together tons 
of obscure serial drivers, advice about how to submit, copies of standards 
documents like unicode.txt, administrative files like 
feature-removal-schedule.txt, debugging advice, userspace API documentation, 
datastructure documentation, design docs, a pointer to where to download the 
firmware for a Cyclades Z (still dunno what that is, but google probably 
would.  README.cycladesZ sure doesn't say...), historical notes like 
highuid.txt...

I'm also trying to figure out what is and isn't documented, so I can fill in 
some of the gaps.  (Or at least _identify_ them.)  Having a great unsorted 
heap of documentation doesn't help this, I need to categorize it to figure 
out the coverage.  (Let alone triaging the quality of what's there and 
figuring out if Linux Weekly News or Kerneltrap or somebodydid a way better 
writeup than what the kernel comes with, and maybe I can poke 'em into 
signing off on putting their version in the kernel.)

Yeah, I've got to read through "make htmldocs" too.  I'm working on it...

> Is there really enough documentation for these that another directory
> level is worthwhile?

You note that my first quick run-through missed half of this category of 
documentation, and then you ask whether or not the grouping is already 
obvious.  Yes, I think there's enough documentation to make another directory 
level worthwhile.

And as long as we're going there please explain why directories like "uml" 
and "telephony" only have one file each in them, but there's 
five "sched-*.txt" files at the root level?  Why is there an ioctl directory 
but ioctl-number.txt isn't in it?  (Maybe there are good answers for this 
other than "different people did different things without talking to each 
other, and documentation is an afterthought anyway".  I don't know.)

> 00-INDEX already covers most of these things, so 
> it's not like there's any measurable confusion..

Following that to its logical conclusion, why do we need subdirectories at 
all?  No, that's not sarcasm, I've actually pondered just making an 
index.html file that bears no relation to the underlying directory structure 
but lets people see "ok, these seven files are about locking, these six files 
are about the development model, these files describe development tools, this 
describes kernel infrastructure, these are busses, these are block 
devices..."

I thought reorganizing Documentation (so people who didn't already know 
everything in it could find things) would be more generally helpful, but if 
that's not the case I'm happy to do my own out-of-tree index instead.  Let me 
know what you prefer.

As to "why start here", the multiport serial drivers are each things that 99% 
of the audience will never use.  Few things even have serial anymore, those 
that do seldom use multiport cards, and when you _do_ have a multiport card 
you're looking for documentation on a specific one and the other half-dozen 
won't help you.  So having them at the root level is just clutter in anything 
remotely like the common case, and there's already a "serial" directory 
(another example of a directory with just one thing in it).

As for architectures, most people manage to avoid caring about the ones they 
don't use (as long as their changes don't break them, something they often 
can't test anyway).  Personally, I do embedded development and play with half 
a dozen architectures (plug: http://landley.net/code/firmware), but most 
people only look at one or two.  Files like "zorro.txt" are something that 
there are probably less than 100 people on the planet who still use it, which 
doesn't mean it's not _valuable_, just that having it at the root level is 
clutter to the vast majority of the userbase and arch/amiga seems like a 
better place for it.

Rob
