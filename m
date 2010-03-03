Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab0CCVsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 16:48:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41393 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756696Ab0CCVsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 16:48:14 -0500
Date: Wed, 3 Mar 2010 13:48:08 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Greg KH <gregkh@suse.de>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 19/62] Driver-Core: devtmpfs - remove EXPERIMENTAL and
 enable it by default
In-Reply-To: <20100303212236.GA9732@suse.de>
Message-ID: <alpine.LFD.2.00.1003031340570.3599@localhost.localdomain>
References: <20100302230933.GA32287@kroah.com> <1267572541-410-19-git-send-email-gregkh@suse.de> <m1635eow8a.fsf@fess.ebiederm.org> <alpine.LFD.2.00.1003030839550.3627@localhost.localdomain> <20100303212236.GA9732@suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Mar 2010, Greg KH wrote:
> 
> Ok, I'll change this.  Do you want me to redo the whole series, or just
> add another patch to revert the 'default y' option here?

I'm ok with just changing the default. I wanted to make a stink over it 
just to make people aware that we already have kernels too big by default, 
and we shouldn't change the default semantics of making a config without 
some major reasons.

Btw, I do think that when you do pull requests during the merge window, 
you should seriously think about basing them on top of some known-stable 
kernel (ie the previous release) rather than some random 
kernel-of-the-day like you seem to.

It's much easier to bisect problems if you'er not fighting multiple 
overlapping bugs, for example - and since you move from quilt to git 
apparently just based on whatever was the most recent git tree when you do 
that move, it really means that in case the kernel you picked was 
unstable, it's going to be a _bitch_ to bisect any problems introduced in 
your series.

Why? Say that the base you picked happened to simply not boot at all (or 
had something like the PCI problem that I encountered that made X not run 
on my machine) for somebody. Now _all_ those commits you did in that 
series are going to be essentially untestable on such a machine - and 
think about what happens if the problem happens mainly on the same 
machines that had the other bug too?

Anyway, I don't know whether you picked a good spot to do your series or 
not, but it _looked_ like a pretty random spot. It might be perfectly 
good. But just in general, since you always generate your trees from a 
quilt series anyway, I suspect we migth be better off (at least for the 
initial merge window series) to base them on the closest thing we have to 
a "known good" base, namely the previous release. Rather than some "maybe 
fine" point in the middle of the merge window.

			Linus
