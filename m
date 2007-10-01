Return-Path: <linux-kernel-owner+w=401wt.eu-S1751862AbXJAHNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbXJAHNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 03:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbXJAHNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 03:13:16 -0400
Received: from barikada.upol.cz ([158.194.242.200]:53423 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbXJAHNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 03:13:14 -0400
To: "Elyse M. Grasso" <emgrasso@data-raptors.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net,
       Andreas Herrmann <aherrman@arcor.de>,
       Eric Van Hensbergen <ericvh@gmail.com>, linux-kernel@vger.kernel.org
Subject: A bit of kconfig rewrite (Re: [PATCH] 9p: fix compile error if !CONFIG_SYSCTL)
In-Reply-To: <200709281112.52844.emgrasso@data-raptors.com>
References: <20070918080537.GA14882@devil> <alpine.LFD.0.999.0709280728170.3579@woody.linux-foundation.org> <200709281005.34001.nickpiggin@yahoo.com.au> <200709281112.52844.emgrasso@data-raptors.com>
User-Agent: slrn + jed (x86_64-pc-linux-glibc-debian)
Date: Mon, 1 Oct 2007 09:27:08 +0200
Message-Id: <E1IcFgK-0005oI-5p@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Fri, 28 Sep 2007 11:12:51 -0600

> On Thursday 27 September 2007, Nick Piggin wrote:
>> On Saturday 29 September 2007 00:34, Linus Torvalds wrote:
>> > On Fri, 28 Sep 2007, Nick Piggin wrote:
>> > > > God I hate select.
>> > >
>> > > IMO a better implementation would result in a notification / 
> confirmation
>> > > of turning on new items, and the ability to deselect options which will
>> > > also confirm to deselect dependants. Like most other systems that have
>> > > similar problem to solve.
>> >
>> > Actually, the *really* nice thing to do would be to just add the reason
>> > something got enabled into the ".config" file.
[]
>> > 	CONFIG_ACPI=y		# selected by X86_64_ACPI_NUMA
>> > 	CONFIG_ACPI_PROCFS=y	# user choice
>> > 	...
[]
>> Sure, that would probably be pretty trivial to implement too, and
>> would solve most problems for kernel devs.
>> 
>> At a level up from that, I think ease of use could be improved with
>> a package manager-type chained-selection/deselection feature in
>> the config tools.
>> 
>> Not that I'm volunteering to implement either ;)
>> 
>> >
>> > That way, there's always a fairly straightforward way to see why some
>> > configuration is the way it is (and the .config file is not only useful
>> > for "make oldconfig", it's also what normally gets passed around for bug
>> > reports, and is part of distro kernel packages etc, so it would seem to be
>> > the right place, no?)
>> >
>> > 		Linus
[]
> Adding the comments to the .config files sounds like a good project for a 
> comparative newbie. By the end of next week I should have hardware available 
> for experimental kernel builds. (And also some free wetware cycles.) 
>
> Are there any other requirements for formatting I should consider? 

No. Not another semi-newbie and/or semi-halfway done job, please.

I'm pretty sure, that Linus is proposing that only after manual
editing of/looking into the `.config' after `make oldconfig`.

Before you will consider anything, please, check recent LKML (kbuild
rewrite) and kbuild-devel(years 2001-2002) archives (assuming, you have
experience with any build/conf things).

Today's kconfig was proposed and accepted in a very unpleasant
circumstances, has very poor design, development and no working
alternative (for 5+ years now).

The basics, i'm trying to put into design of the new kconfig, as part of
my kbuild (already described a bit)/kconfig rewrite are:

* flexible configuration development(kdevs) and process(kusers)

  + shell-like[0] (not like CML1, which is just shell) scripting, allowing
    to extend easily (if there is no one available) capabilities,
    config values or actions for particular sub-system or compilation
    unit,
    
  [0] if somebody would like to see *a* shell-like scripting:
      ftp://flower.upol.cz/geloiwa/src/usr/local/etc/geloiwa/iwant

  + duplex travelling, multi- looking at/changing of config items,

  + flexible, yet built-able, connections in dependency chain (tree,
    graph, whatever);

* resulting config file capable of producing exact config results of the
  build on any other setup
  (e.g. no ARCH=, CROSS_*, *_FLAGS *kbuild* things);

* checking tool for particular config patterns (for bug reports)

* system itself must be done with minimum requirements for C libraries
  (no ncurses) and tools (no `perl`, no `python`, no `make`).

> In a case where option A is specified by option B which is specified by option 
> C which is specified by option D, should the comment on A mention B, or D or 
> all three items in the chain? 

Fsck it. All must be done by a machine with maximum comfort of users (not
particularly humans), even for those, who like to edit config like so:

`sed -i 's/SYSFS=y/SYSFS="please, NO!!!"/' .config`

--
-o--=O`C
 #oo'L O
<___=E M
