Return-Path: <linux-kernel-owner+w=401wt.eu-S1762058AbYD3Rgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762058AbYD3Rgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 13:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758423AbYD3Rg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 13:36:28 -0400
Received: from barikada.upol.cz ([158.194.242.200]:48832 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756588AbYD3Rg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 13:36:27 -0400
To: Matthew Wilcox <matthew@wil.cx>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Adrian Bunk <bunk@kernel.org>,
       linux-kbuild@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: "Anyone who likes complexity and fuzzy logic" (Re: [PATCH] headerdep:...)
In-Reply-To: <20080426161714.GR14990@parisc-linux.org>
References: <20080426134554.GA20727@damson.getinternet.no> <20080426161714.GR14990@parisc-linux.org>
User-Agent: slrn + jed (x86_64-pc-linux-glibc-debian)
Date: Wed, 30 Apr 2008 19:57:16 +0200
Message-Id: <E1JrGYO-0000Li-K6@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox @ Sat, 26 Apr 2008 10:17:14 -0600:

> I think a more useful tool would be one which mapped something like
> 'use of down()' to 'needs to include <linux/semaphore.h>'.  It needs
> to be at least somewhat done by hand because there are rules such
> as 'include linux/spinlock.h to get spinlock_t' (which is actually
> defined in linux/spinlock_types.h), but you want people to include
><linux/completion.h> directly rather than rely on it being pulled in
> through linux/sched.h, for example.
>
> It's further complicated by multi-file drivers, such as qla2xxx.  Each
> file includes qla_def.h which includes a lot of the necessary header
> files for them ... but then each file will include a few more header
> files that it needs.
(gee...)
> So some implicit includes are _good_ and other implicit includes are
> _bad_ (as they hurt when trying to rationalise the header files).
> Anyone who likes complexity and fuzzy logic like this want to take a
> stab at writing such a tool?

Why? Why GNU C compiler developers didn't do such (obviously useful)
tool? C compiler (some part of it) *is* responsible for parsing,
tokenizing, etc. Why there is development of never-ending buggy
optimizations only[0]?


Matthew, i know you've asked for regular expressions ninjas once, here
simple example.

Syntax highlighting for text editors is the most notable
invention/implementation for ease of programming in last 20 years or so.

Question: why any parser, e.g. GNU/FOSS [C, SED, AWK, ELISP], Perl,
Python, do NOT have option to output OWN highlighted syntax? Don't those
parsers know what they parse, rules, syntax errors, etc.[1]? (Note: at
least framework in parser, so that trivial extending/configuring would be
possible).


Is it really so complex?


=[0]= rant =[0]=

Isn't that hardware had developed in exponential rate toward speed and
cache/RAM size, so any bloat and huge volumes of sources without flexible
configuration systems (to download and work with e.g. only one GCC or
Linux port) are handled quickly?

=[1]= rant =[1]=

No, unreadable and buggy regexp-based highlighting is everywhere with
never-ending features added WRT basic regular expressions!

For those Perl hackers out there: why mister Wall is attributed to
invent non greedy RE match, why he did so by introducing non portable
and non-readable syntax to already crappy RE?

Simple BRE based idea: '\{0, s\}'. Just like `sed` had overcame second
RE basic pronciple: first-match, by using flags 's///here'.

No, let's invent crutches!

Oh, crap....
--
sed 'sed && sh + olecom = love' << ''
-o--=O`C
 #oo'L O
<___=E M
