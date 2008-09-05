Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbYIEUOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbYIEUOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 16:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbYIEUO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 16:14:26 -0400
Received: from r00tworld.com ([212.85.137.21]:52406 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbYIEUOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 16:14:25 -0400
From: pageexec@freemail.hu
To: Ingo Molnar <mingo@elte.hu>
Date: Fri, 05 Sep 2008 21:37:42 +0200
MIME-Version: 1.0
Subject: Re: [patch] Add basic sanity checks to the syscall execution patch
Reply-to: pageexec@freemail.hu
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       tglx@tglx.de, hpa@zytor.com
Message-ID: <48C18A86.22801.4E3EE62@pageexec.freemail.hu>
In-reply-to: <20080905165239.GA12645@elte.hu>
References: <20080905154221.GF10292@elte.hu>, <48C15D0A.6363.4324231@pageexec.freemail.hu>, <20080905165239.GA12645@elte.hu>
X-mailer: Pegasus Mail for Windows (4.50 PB1)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Fri, 05 Sep 2008 21:38:11 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 Sep 2008 at 18:52, Ingo Molnar wrote:

> * pageexec@freemail.hu <pageexec@freemail.hu> wrote:
> 
> > > i think Linux is fundamentally different here as we have the source 
> > > code, and could apply the randomization technique i mentioned:
> > 
> > how's that supposed to work for the binary distros, i.e., the majority 
> > of end users? [...]
> 
> it takes less than 10 minutes to build a full kernel on recent hardware. 

provided the end user wants/needs to have the whole toolchain on his boxes
at all. how many really do?

> Can be done in the background after install or so.

it's not only installation time (if you meant 'installing the box' itself),
but every time the kernel is updated, so the toolchain will be there forever.

> > [...] and who would look at all the bugreports from such kernels?
> 
> yes, in this area debuggability is in straight conflict. Since we can 
> assume that both attacker and owner has about the same level of access 
> to the system, making the kernel less accessible to an attacker makes it 
> less accessible/debuggable to the owner as well.

in other words, it's a permanently unsolved problem ;). somehow i don't see
Red Hat selling RHEL for production boxes with the tag 'we do not debug crashes
here because we cannot' attached.

> > > a successful attack that wants to disable the checks
> > 
> > why do you assume that an attacker wants to do that? it's equally 
> > possible, and there's even academic research on this in addition to 
> > the underground cracking scene, that one simply hides the 
> > modifications from the checker.
> > 
> > from marking your patched code as unreadable to executing it from a 
> > different place than what the checker checks, there're many ways to 
> > trick such checkers. as far as reality goes, it's never been game over 
> > ;).
> 
> well at least in the case of Linux we have a fairly good tally of what 
> kernel code is supposed to be executable at some given moment after 
> bootup, and can lock that list down permanently until the next reboot, 

so no module support? what about kprobes and/or whatever else that generates
code at runtime?

> and give the list to the checker to verify every now and then?

so good-bye to large page support for kernel code? else there's likely
enough unused space left in the large pages for a rootkit to hide.

what if the rootkit finds unused pieces of actual code and replaces
that (bound to happen with those generic distro configs, especially
if you have to go with a non-modular kernel)?

last but not least, how would that 'lock that list down' work exactly?
what would prevent a rootkit from locating and modifying it as well?

> Such a verification pass certainly wouldnt be cheap though: all kernel 
> pagetables have to be scanned and verified, plus all known code (a few 
> megabytes typically), and the key CPU data structures.

what would you verify on the code? it's obfuscated so you can't really
analyze it (else you've just solved the attacker's problem), all you can
do is probably compute hashes but then you'll have to take care of kernel
self-patching and also protecting the hashes somehow.

