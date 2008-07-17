Return-Path: <linux-kernel-owner+w=401wt.eu-S1760068AbYGQPsD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068AbYGQPsD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 11:48:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756809AbYGQPrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 11:47:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754793AbYGQPrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 11:47:51 -0400
Date: Thu, 17 Jul 2008 08:47:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       torvalds@linuxfoundation.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: Please pull ACPI updates
In-Reply-To: <alpine.LFD.1.10.0807170807040.2959@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807170835320.2959@woody.linux-foundation.org>
References: <20080716214516.GA10777@basil.nowhere.org> <200807170011.12184.rjw@sisk.pl> <200807161633.01375.jbarnes@virtuousgeek.org> <487EEAEB.4050009@firstfloor.org> <alpine.LFD.1.10.0807170807040.2959@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Jul 2008, Linus Torvalds wrote:
> 
> That's the whole point of topic branches. They allow you to separate out 
> work to different areas, so that people who are interested in (say) the 
> PCI-impacting ones can merge with one part, without having to wait for the 
> other parts to stabilize.

Btw, you don't really have to have a lot of them.

When it comes to ACPI in particular, I would really prefer to see at least 
the ACPICA stuff in a separate topic branch. It comes in from a different 
source, it's maintained separately, and when it causes problems(*) it ends 
up usually being handled differently too.

Len additionally split things like bugzilla entries up into individual 
topics, and that was really nice to see when merging, but I have to say 
that it was also "above and beyond" what I've ever expected of any 
maintainer. That said, I think ACPI has been rather bugzilla-driven (many 
other areas are feature-driven), and I do think it makes tons of sense to 
put fixes in different branches, and then you can merge them when you 
actualyl close the bug when the fix has been verified.

So one reason I reacted strongly to the ACPI change was definitely just 
that ACPI used to be one of the really nicely done subsystems (not just 
from a git standpoint, but the whole git flow was part of it). There were 
some issues very early on in git usage, but I gave a shout-out to Len at 
the last kernel summit for a reason.

And in that sense it's definitely unfair to require quite _that_ level of 
separation. I'm really not expecting it. 

But I *really* hate pulling from somebody, and seeing commit dates that 
are from five minutes ago, and based on something that I had just pushed 
out (which was essentially the case for this round of ACPI changes).

That literally shows that the code was hardly tested _at_all_ in that 
exact configuration. It may have gotten testing based on some earlier 
kernel version, but then it very clearly got rebased (or just quilt 
imported) on top of a totally new kernel base, and was not tested in that 
version very much if at all.

So even if you end up using quilt, I'd suggest you do so on a specific 
base, rather than on some random "kernel-of-the-moment-in-the-middle- 
of-the-merge-window". Because then at least I feel like the people 
involved have been doing their own development without having the rug 
pulled out from them all the time by using a different kernel as a base.

		Linus

(*) Which is happily fairly rare these days! I obviously detest the 
complexity that is ACPI, but even if I detest it, Intel should get cudos 
for getting it to work.
