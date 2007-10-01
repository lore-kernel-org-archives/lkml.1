Return-Path: <linux-kernel-owner+w=401wt.eu-S1752673AbXJAMxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbXJAMxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 08:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbXJAMxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 08:53:39 -0400
Received: from phobos03.frii.com ([216.17.128.163]:59029 "EHLO mail.frii.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751736AbXJAMxi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 08:53:38 -0400
From: "Elyse M. Grasso" <emgrasso@data-raptors.com>
To: Oleg Verych <olecom@flower.upol.cz>
Subject: Re: A bit of kconfig rewrite (Re: [PATCH] 9p: fix compile error if !CONFIG_SYSCTL)
Date: Mon, 1 Oct 2007 06:53:35 -0600
User-Agent: KMail/1.9.6
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net,
       Andreas Herrmann <aherrman@arcor.de>,
       Eric Van Hensbergen <ericvh@gmail.com>, linux-kernel@vger.kernel.org
References: <20070918080537.GA14882@devil> <200709281112.52844.emgrasso@data-raptors.com> <E1IcFgK-0005oI-5p@flower>
In-Reply-To: <E1IcFgK-0005oI-5p@flower>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710010653.35976.emgrasso@data-raptors.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 October 2007, Oleg Verych wrote:
> * Fri, 28 Sep 2007 11:12:51 -0600
> 
> > On Thursday 27 September 2007, Nick Piggin wrote:
> >> On Saturday 29 September 2007 00:34, Linus Torvalds wrote:
> >> > On Fri, 28 Sep 2007, Nick Piggin wrote:
> >> > > > God I hate select.
> >> > >
> >> > > IMO a better implementation would result in a notification / 
> > confirmation
> >> > > of turning on new items, and the ability to deselect options which 
will
> >> > > also confirm to deselect dependants. Like most other systems that 
have
> >> > > similar problem to solve.
> >> >
> >> > Actually, the *really* nice thing to do would be to just add the reason
> >> > something got enabled into the ".config" file.
> []
> >> > 	CONFIG_ACPI=y		# selected by X86_64_ACPI_NUMA
> >> > 	CONFIG_ACPI_PROCFS=y	# user choice
> >> > 	...
> []
> >> Sure, that would probably be pretty trivial to implement too, and
> >> would solve most problems for kernel devs.
> >> 
> >> At a level up from that, I think ease of use could be improved with
> >> a package manager-type chained-selection/deselection feature in
> >> the config tools.
> >> 
> >> Not that I'm volunteering to implement either ;)
> >> 
> >> >
> >> > That way, there's always a fairly straightforward way to see why some
> >> > configuration is the way it is (and the .config file is not only useful
> >> > for "make oldconfig", it's also what normally gets passed around for 
bug
> >> > reports, and is part of distro kernel packages etc, so it would seem to 
be
> >> > the right place, no?)
> >> >
> >> > 		Linus
> []
> > Adding the comments to the .config files sounds like a good project for a 
> > comparative newbie. By the end of next week I should have hardware 
available 
> > for experimental kernel builds. (And also some free wetware cycles.) 
> >
> > Are there any other requirements for formatting I should consider? 
> 
> No. Not another semi-newbie and/or semi-halfway done job, please.
> 
> I'm pretty sure, that Linus is proposing that only after manual
> editing of/looking into the `.config' after `make oldconfig`.
> 
> Before you will consider anything, please, check recent LKML (kbuild
> rewrite) and kbuild-devel(years 2001-2002) archives (assuming, you have
> experience with any build/conf things).
> 
> Today's kconfig was proposed and accepted in a very unpleasant
> circumstances, has very poor design, development and no working
> alternative (for 5+ years now).
> 
> The basics, i'm trying to put into design of the new kconfig, as part of
> my kbuild (already described a bit)/kconfig rewrite are:
> 
> * flexible configuration development(kdevs) and process(kusers)
> 
>   + shell-like[0] (not like CML1, which is just shell) scripting, allowing
>     to extend easily (if there is no one available) capabilities,
>     config values or actions for particular sub-system or compilation
>     unit,
>     
>   [0] if somebody would like to see *a* shell-like scripting:
>       ftp://flower.upol.cz/geloiwa/src/usr/local/etc/geloiwa/iwant
> 
>   + duplex travelling, multi- looking at/changing of config items,
> 
>   + flexible, yet built-able, connections in dependency chain (tree,
>     graph, whatever);
> 
> * resulting config file capable of producing exact config results of the
>   build on any other setup
>   (e.g. no ARCH=, CROSS_*, *_FLAGS *kbuild* things);
> 
> * checking tool for particular config patterns (for bug reports)
> 
> * system itself must be done with minimum requirements for C libraries
>   (no ncurses) and tools (no `perl`, no `python`, no `make`).
> 
> > In a case where option A is specified by option B which is specified by 
option 
> > C which is specified by option D, should the comment on A mention B, or D 
or 
> > all three items in the chain? 
> 
> Fsck it. All must be done by a machine with maximum comfort of users (not
> particularly humans), even for those, who like to edit config like so:
> 
> `sed -i 's/SYSFS=y/SYSFS="please, NO!!!"/' .config`
> 
> --
> -o--=O`C
>  #oo'L O
> <___=E M
> 

I did not see a requirement for a major rewrite for a tool or a toolset. I saw 
a requirement for one specific improvement to the output of one specific 
program. It seems to be an improvement that will provide immediate benefits, 
so is worthwhile even if it will eventually be superceded by a new generation 
of the tool..

After making my living as a software engineer for the past 26 years, I know 
better than to start learning a new environment by setting out to make major 
architectural changes. Or without adequately detailed requirements (even if 
they are self-generated). Apparently the newbies you complain about have not 
learned these lessons yet, leading to incomplete and unfinished projects. 

When I have used this little project as a gateway into the toolset, I might 
consider taking part in your larger redesign project as a follow on, if you 
can provide more detailed and coherent specifications for what you want done. 

Or not. 

In this case, no one is paying me to deal with inadequate specifications and 
rude people, so I may find something else to do with my spare time and 
equipment. 

-- 
Elyse Grasso

http://www.data-raptors.com    Computers and Technology
http://www.astraltrading.com   Divination and Science Fiction
http://www.data-raptors.com/global-cgi-bin/cgiwrap/emgrasso/blosxom.cgi WebLog
