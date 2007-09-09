Return-Path: <linux-kernel-owner+w=401wt.eu-S1755946AbXIIBGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbXIIBGV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 21:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbXIIBGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 21:06:13 -0400
Received: from barikada.upol.cz ([158.194.242.200]:52095 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbXIIBGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 21:06:12 -0400
To: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Cc: <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Early userspace, Linux development (Re: perhaps init/ should update the reference to "change floppy")
In-Reply-To: <Pine.LNX.4.64.0709080802430.8930@localhost.localdomain>
References: <Pine.LNX.4.64.0709080802430.8930@localhost.localdomain>
Date: Sun, 9 Sep 2007 03:21:20 +0200
Message-Id: <E1IUBUG-0003nA-W2@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Sat, 8 Sep 2007 08:08:06 -0400 (EDT)
[]
>   from init/do_mounts_rd.c:
>
> ...
[]
>         if (rd_prompt)
>                 change_floppy("root floppy disk to be loaded into RAM disk");
>         create_dev("/dev/root", ROOT_DEV);
>         create_dev("/dev/ram", MKDEV(RAMDISK_MAJOR, n));
>         return rd_load_image("/dev/root");
> }
> ...
>
>   but isn't it a bit archaic to suggest that an explicit ramdisk will
> be found only on a floppy?  can't one be provided on a CD or DVD?
> just suggesting that the terminology could probably be updated.

All this is userspace code, ugly, unmaintained and all that kind of
things.

== Kernel panics without userspace, do you need such kernel? ==

The klibc project[0] was started 5 years ago to have usable kernel early
userspace with *usable* userspace. Status still unknown, but still better
than anything else in every distro, having NIH things just to boot-up
Linux.

[0] http://www.zytor.com/mailman/listinfo/klibc

I'd like to propose KJ as well as KN to look on that project and start to
be real userspace geeks first, before touching kernel and it's real
developers with (hopefully non-silly) stuff. Benefits:

* better understanding basic problems, like userspace API/ABIs
* know "how to" and actual produce tests easily
* improve development process: tools, ways of doing dev. thing, etc.
* have better results with kernel patches

My opinion is, that real developer must be very good user first. And
ordinary tools for that are shell, core utils (compare usage of it for
instance[1,2]). Having almost zero review of kernel development tools usage
and algos, complicated by people like Adrian[2], is not place to go in future
(and present, btw).

[1] http://marc.info/?l=linux-kernel&m=118868338702120
[2] http://marc.info/?l=linux-kernel&m=118911074923392

Only active kbuild developer -- Sam is almost always reply to poking
messages in form of "not much time for kernel-work"[2]. This is main
reasot to have kbuild system split per directory basis. Where most top
ones are actual subsystems. Scripting, inside those directories is due
of local developers/maintainers.

This includes needed CC/LD options checking and workarounds, maybe even
optimizations, if available. Traking of exported out kconfig sysmbols,
making sure nothing leaks, so no problems with dependency, if usage of
exports is agreed (e.g. usb and network). Local symbols must apear only
inside directory. This will simplyfy and speed up pre-build process. In
such configurations Intel developers may have their `imake` inside build
scripts if necessary :). Users may close loop by feed back what is
more approptiate for them in default options, tools.

Again, making sure, that tools are available is problem of local scripts.
Shell have `hash`, so hash all what is in use, and report problem before
any run. Checking versions has no problem at all. If nobody cares much
inside particular directory, then top configuration interface will show
this by means of time-stamp checks or something like that. Help messages
as well as scripts may have more information in categories, like

* users: "enable this, and you will do cool stuff, noone have!!!"

* testers: "run test1, 2, 3 and report if anything wrong after 896fg8"

* developers: "we do this this and that, because of foo and bar"

* distriutions: "state of this implementation/feature is buzz, we not
  sure it's stable for production on ARCH xBAZZ yFAZZ, etc."

Making UI for this is PITA, but ordinary text/stream editor is OK to
start with. I have more to say and show, but latter.

[3] http://marc.info/?l=linux-kernel&m=118777006621795

So, not seeing a tip of iceberg, Linux may hit very serious problems
due to this. And under own pressure in might collapse very easily.
Isn't it better to have Linux development as a nice place to spend
time comfortably, rather than running toward world domination, like
bulldozer, getting more and more burden? Did you saw that `MAINTAINERS'
patches?

Example is same guy -- Adrian, who refused to reply to any messages
regarding maintaining "util-linux". Yes, this is boring job, it's not
like to argue and saying in LKML to others what to do (see later [2]).
His great KJ efforts are known, but yet no tools, only text editor.
Denys has put everything together, including special kernel linking
magic. This bring individual developers way of monitoring of their
developed drivers/subsystems/other sources. Thus `make static` patches
may flow from exact developers, if they will know how to do it
(kconfig/ifdefery issue left out here).

I have nothing personal, just example.

I may or may not have success in my kbuild rewite[4], i don't care.
Anyway. I will start with klibc, using only klibc as tools and then
slowly transform build system to rapid kernel development some time
latter.

[4] http://marc.info/?l=linux-kernel&m=118885530622319

--
-o--=O`C
 #oo'L O
<___=E M
