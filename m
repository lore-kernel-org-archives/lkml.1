Return-Path: <linux-kernel-owner+w=401wt.eu-S1752489AbXCDVh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbXCDVh4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 16:37:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbXCDVh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 16:37:56 -0500
Received: from raven.upol.cz ([158.194.120.4]:41218 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489AbXCDVhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 16:37:55 -0500
To: "FN" <zzzz444@ml1.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: module builds need improvement / top Makefile not good enough
In-Reply-To: <1172855662.23830.1177403935@webmail.messagingengine.com>
References: <1172855662.23830.1177403935@webmail.messagingengine.com>
Date: Sun, 4 Mar 2007 22:47:45 +0100
Message-Id: <E1HNyYT-00086z-27@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: "FN"
> Newsgroups: gmane.linux.kernel
> Subject: module builds need improvement / top Makefile not good enough
> Date: Fri, 02 Mar 2007 09:14:22 -0800

> Hello list,

Hallo.

> I am unhappy with the direction the 2.6 kernel builds have taken.
> Very much like Micro$loth DDKs we (linux users) are being forced to
> build
> modules by plugging into a framework that doesn't respect the fine
> aspects
> of dependency generation and analysis.

Ideas in form of patches are accepted,

> Two problems I've identified
> 1. module builds are forcing me to use a particular make program (gnu
> make)
>    Well, what if someone uses a different tool to express the DAG (dep.
>    graph)?

with multiple stat()/clone()/exec(cc), i.e. `make' replacement, tools support,

> 2. gnu make is a somewhat dated program and can't do profound dependency
>    generation and analysis like some newer tools. All it can do is
>    produce
>    .d from .c with the -MM option using an idiom like this
>      -include f1.d f2.d
>       %.d: %.c
>          $(CC) -MM <whatever>

AFAIK GNU make have nothing to do with any kind of decencies,

>    But that's not good enough for 2 reasons.
>    a) version rollback that causes timestamp rollback in time does NOT
>       trigger regeneration of dependencies (e.g. clearcase based
>       builds).
>    b) dependencies on order of things can't be expressed in gnu make,
>    for
>       example -Iinc1 -Iinc2 causes different results from -Iinc2 -Iinc1
>       if you have 2 different header files that have the same name in
>       both
>       directories. Same goes for "ld -r -o mod.o f1.o f2.o" vs 
>       "ld -r -o mod.o f2.o f1.o" if order mattered (which it doesn't in
>       this case).

see kbuild implementation to know how preparation done before GNU make
is used,

>    Bottom line - there exist free tools that are vastly superior to gnu
>    make,
>    one such example is omake, and I don't want you to force me to switch
>    to
>    inferior dependency analysis with gnu make.

(note: supported and well maintained free tools).

> My suggestion how to solve this problem is the following.
> Instead of
> gnumake -C /lib/modules/`uname -r`/build M=`pwd` modules
> it's better to be able to do 
> gnumake -C /lib/modules/`uname -r`/build M=`pwd` MYMAKE=mymake modules 
> and then inside your gnu Makefile you'd call mymake like so
>
> chdir $(M)
> mymake MODFLAGS="whatever modflags" INCFLAGS="whatever incflags" modules
> and pass on whatever flags are necessary.
>
> You can set MYMAKE to gmake if unspecified thus "MYMAKE ?= make"
>
> That would make the callback into the user's build environment clean and
> unbind it from gnu make.

I doubt this suggestion. I think, as GNU make is current good and
supported stat()/clone()/exec(cc) tool, one must provide
gnu-make-with-kbuild-tools independent configuration and dependency  building
process. And having multiple-pluging for dep-build and cc-build
tools, it may be suitable for guys like kbuild developers, you and me.

> Any replies, critique -- cc me, as I am not on this list.

If you can't follow LKML yet, please find little-nice kbuild ML in the
MAINTAINERS file. And IMHO, this (cc me) already must be in some kind of
"how to ask questions in the smart way" or Newbie's Netiquette, as bed
example of introduction of yourself.

> -- 
>   FN
>   zzzz444@ml1.net
>
> -- 
  http:// www@fastmail.fm - And now for something completely different?
>

See you later?
--
-o--=O`C
 #oo'L O
<___=E M
