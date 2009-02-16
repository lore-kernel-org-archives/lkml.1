Return-Path: <linux-kernel-owner+w=401wt.eu-S1755501AbZBPPWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbZBPPWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 10:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755120AbZBPPWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 10:22:34 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:56509 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029AbZBPPWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 10:22:33 -0500
Message-ID: <499984C1.6020004@s5r6.in-berlin.de>
Date: Mon, 16 Feb 2009 16:22:41 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Sam Ravnborg <sam@ravnborg.org>, Manish Katiyar <mkatiyar@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Remove errors caught by checkpatch.pl in	kernel/kallsyms.c
References: <ea11fea30902151034s5444efabw455c1dac1b875086@mail.gmail.com> <20090215184752.GA4970@uranus.ravnborg.org> <4999650C.6030700@s5r6.in-berlin.de> <20090216132822.GC17996@elte.hu> <4999717F.7090205@s5r6.in-berlin.de> <20090216141917.GA8981@elte.hu>
In-Reply-To: <20090216141917.GA8981@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> We routinely mention Sparse, lockdep, Coverity, Coccinelle, kmemleak, 
> ftrace, kmemcheck and other tools as well when it motives to fix a bug 
> or uncleanliness. [...] It is absolutely fine to
> mention checkpatch when it catches uncleanliness in code that already 
> got merged. I dont understand your point.

I wrote "don't mention checkpatch" but I really meant "think about what
the effect of the patch is and describe this".

It's not really a hard problem to mention checkpatch --- it is a problem
to make it the main point or, like in this case, the only point of the
changelog.  (Furthermore, it is also a problem to do something routinely
*if* doing it does not make sense.  There routinely appear coccinelle
metapatch sources in changelogs.  That does not make sense at all, and
doing it routinely is not a justification in itself.)

So, "don't mention checkpatch" is simply a rule of thumb; read it as "I
mentioned checkpatch in the changelog --- wait, I have possibly written
a changelog that is besides the point; I should think about it once
more".  :-)

Now, when this particular patch is updated to get a good changelog, then
the title could become e.g.:
	kernel/kallsyms: change initcall level; adjust whitespace
and anything more than that is just fluff and wasted electrons. Actually
the changelog should rather contain a note on why device_initcall is
supposed to be the correct initcall level.

Fixes due to reports from sparse, lockdep, coverity, coccinelle, etc.
are the in this respect the same as fixes due to reports from
checkpatch:  Patch titles should for example be
  - "fix potential deadlock..."
  - "fix use-after free..."
  - "use XYZ helper..."
  - "adjust whitespace..."
and *not* something like "fix lockdep backtrace" or whatever.

A difference would be a patch title like "add sparse annotations"
because this is indeed about what the patch does, not by which means it
was created.

Why do I make a fuzz?  Well, because many of our changelogs really suck
and we need to become better in general.
-- 
Stefan Richter
-=====-=-=== -=-= -==-=
http://arcgraph.de/sr/
