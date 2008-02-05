Return-Path: <linux-kernel-owner+w=401wt.eu-S1753344AbYBEPAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbYBEPAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 10:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbYBEPA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 10:00:29 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36684 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbYBEPA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 10:00:29 -0500
Date: Tue, 5 Feb 2008 07:00:01 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Pavel Machek <pavel@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Abel Bernabeu <abel.bernabeu@gmail.com>
Subject: Re: brk randomization breaks columns
Message-ID: <20080205070001.7bc8058f@laptopd505.fenrus.org>
In-Reply-To: <Pine.LNX.4.64.0802051243240.542@blonde.site>
References: <20080204122837.GA1647@elf.ucw.cz>
	<Pine.LNX.4.64.0802050242440.30873@twin.jikos.cz>
	<Pine.LNX.4.64.0802051243240.542@blonde.site>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> But I was myself surprised by your randomize_brk patch: like the
> buggy program, I'd imagined that data immediately followed by bss
> immediately followed by brk was an invariant (whereas I never
> supposed the position of the code had anything to do with it).
> Just my ignorance, but not surprising if it's shared by others.

the surprise also will be when gcc reorders your .data section for optimization,
and the variable you think is last.. no longer isn't.

> 
> So, I didn't really expect the randomize_brk patch to get this far,
> thought it would hit trouble earlier.  What to do now?  On the one
> hand Pavel rightly regards this as a regression, on the other hand
> we've had programs which make bad assumptions about their address
> space layout before, and have not always deferred to them.
> 
> If such cases are few (can we be sure of that yet?), is it going

it's for sure only few; this is the second known case is 5 years
that made this dicey assumption (RHEL/Fedora ship with this for 5 years or so now)
Various "secure" distros ship with brk detached as well (albeit via other methods)
for even longer.

> to be good enough to rely on adding the ELF note to disable their
> randomization?

sadly elfnotes are a sparse commodity.
> 
> In my usual dither, I'm rather hoping Arjan will have a clear answer.


setarch works. If the apps come in source form they need fixing anyway (since I'd not be
surprised of current gcc reorders variables), if not.. we only have 2 cases,
the other case was the build process of emacs (which got fixed 5 years ago).
My personal guess is, if there's nothing more than "columns", lets swallow it.
If more show up, we need to rethink it. I somehow doubt more real apps will show
up given how widespread and long this patch was deployed... but turning of randomization
already exists via various methods, both global and per process.
