Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbYFAIiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbYFAIiV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 04:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbYFAIiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 04:38:06 -0400
Received: from winston.telenet-ops.be ([195.130.137.75]:56784 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbYFAIiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 04:38:04 -0400
Date: Sun, 1 Jun 2008 10:37:59 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@elte.hu>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k libc5 regression
In-Reply-To: <20080601005338.3affe880.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0806011035420.5559@anakin>
References: <Pine.LNX.4.64.0805262226280.11902@anakin>
 <Pine.LNX.4.64.0805270014110.6718@jikos.suse.cz>
 <20080601005338.3affe880.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jun 2008, Andrew Morton wrote:
> On Tue, 27 May 2008 00:19:32 +0200 (CEST) Jiri Kosina <jkosina@suse.cz> wrote:
> > From: Jiri Kosina <jkosina@suse.cz>
> > 
> > brk: check lower bound properly
> > 
> > The check in sys_brk() on minimum value the brk might have must take 
> > CONFIG_COMPAT_BRK setting into account. When this option is turned on 
> > (i.e. we support ancient legacy binaries, e.g. libc5-linked stuff), the 
> > lower bound on brk value is mm->end_code, otherwise the brk start is 
> > allowed to be arbitrarily shifted.
> > 
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> OK, we have a problem here.
> 
> Somebody has gone and checked this patch into their tree and it now
> appears in linux-next.
> 
> I do not know how to work out how this patch got into linux-next.

Through quilt/m68k

> It's not in any of the trees which I pull so I guess that person has
> been shuffling URLs without telling me.

... which is not in your tree, AFAIK.

> One of the reasons this is bad is that, frankly, I trust almost nobody
> to remember to backport fixes into 2.6.25.x.  I'm not even at all
> confident that our mystery new part-time memory management maintainer
> will remember to merge this into 2.6.26.  The fact that this person
> failed to add a Cc:stable@kernel.org to the changelog doesn't inspire
> confidence.

It's on my (m68k) list for 2.6.26...
And as soon as it's in, I was going to tell stable...

> I shall merge this fix into my tree (y'know - the one where memory
> management patches are hosted) and I'll get it into 2.6.26 and shall
> offer it to the -stable team.  This will cause me to get collisions
> with the duplicated patch in linux-next but fortunately it is small. 
> This time.

So what's the appropriate way to handle this?
I should have kept it in the m68k series after NEXT_PATCHES_END, so
nobody sees it exists?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
