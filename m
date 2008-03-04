Return-Path: <linux-kernel-owner+w=401wt.eu-S1763190AbYCDRqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763190AbYCDRqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 12:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761528AbYCDRpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 12:45:36 -0500
Received: from c60.cesmail.net ([216.154.195.49]:62096 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761181AbYCDRpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 12:45:35 -0500
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use GPL-only
	symbols
From: Pavel Roskin <proski@gnu.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Zan Lynx <zlynx@acm.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <alpine.LFD.1.00.0803040907420.12253@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0802290807110.17889@woody.linux-foundation.org>
	 <1204304352.6767.21.camel@localhost>
	 <alpine.LFD.1.00.0802290906520.17889@woody.linux-foundation.org>
	 <1204305609.21719.16.camel@dv>
	 <alpine.LFD.1.00.0802290929590.17889@woody.linux-foundation.org>
	 <1204313978.2316.8.camel@dv> <20080229211513.GI27212@elte.hu>
	 <1204324265.2316.70.camel@dv> <20080303105752.GA23594@elte.hu>
	 <20080304003723.z79pcavdk4wgoc44@webmail.spamcop.net>
	 <20080304125744.GF29777@elte.hu>
	 <alpine.LFD.1.00.0803040907420.12253@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 12:45:32 -0500
Message-Id: <1204652732.2312.18.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-04 at 09:19 -0800, Linus Torvalds wrote:

> Ingo, i's simply not possible to put ndiswrapper in user-space sanely.
> 
> Drivers are drivers. They'll want (shared) interrupts, they want DMA, they 
> want to do things like cli/sti. 

Agreed.

> The USB drivers *may* be abstracted enough that they don't do any of that, 
> but quite frankly, I doubt it.

And even then, we need a network interface in the kernel, which would
possibly support wireless extensions.

And most importantly, I don't think anyone will bother rewriting
ndiswrapper.  It's a popular project amongst users, but it suffers from
little attention of developers.

> So asking people to make ndiswrapper be user-mode only is simply not 
> realistic.

Agreed.

> The question on the table is not whether we can make it user-mode 
> (especially since no major kernel contributor is likely to even care 
> enough to really help code anyway), but whether we should let ndiswrapper 
> continue using GPLONLY symbols.

Yes.

> Quite frankly, my position on this has always been that the GPLv2 
> explicitly covers _derived_ works only, and that very obviously a Windows 
> driver isn't a derived work of the kernel. So as far as I'm concerned, 
> ndiswrapper may be distasteful froma technical and support angle, but not 
> against the license.

Nice to hear that.

> So I'm personally perfectly happy to say that we should revert that commit 
> 0aa5bd52d0c49ca56d24584c646e6544ccbb3dc9, but what I've wanted to hear 
> from the very beginning was simply to get a list of symbols that currently 
> clash, and hear from the people who maintain the symbols whether they 
> really meant for that commit to be valid.

To recap:

1) USB API
2) Workqueue API (there is a hackish replacement in ndiswrapper)
3) task_nice(), but I have a trivial workaround for that.

> That's the only issue here. Not whether ndiswrapper could do a part of its 
> job in user space (because the answer to that latter question is: no. 
> Everything is "possible", of course, but realistically, that's simply not 
> going to happen).
> 
> It sounds like there aren't that many symbols affected at the core: the 
> workqueue stuff certainly isn't worth bothering about. The USB things that 
> ndiswrapper wants is much more involved, and more likely to have issues, 
> but I'm cc'ing Greg here to see.
> 
> IOW: I _personally_ don't think there are any license issues, but I do 
> want to have the situation clear to people involved.

Let me explain my position.  Using of GPL-only symbols by ndiswrapper
has been tolerated for years.  The change was not even intended to stop
it.  It was a side effect.

As it stands now, I don't want to be in the position to ask anyone to
add extra support to recognize ndiswrapper or to have some ugly
EXPORT_SYMBOL_GPL_OR_NDISWRAPPER.

Believe me, I don't want to be uncooperative.  But I think I'll be in
the position to ask for exceptions for ndiswrapper only if somebody is
actively and _intentionally_ looking to prevent it from using GPL-only
symbols.  That's why if nothing changes in the kernel, ndiswrapper will
be renamed.  This way we'll see if anyone actually cares enough to block
ndiswrapper again.  And in this situation, I'll be in a better position
to ask authors of the workqueue API and USB for an explicit exception.

-- 
Regards,
Pavel Roskin
