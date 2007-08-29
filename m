Return-Path: <linux-kernel-owner+w=401wt.eu-S1757819AbXH2UWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819AbXH2UWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 16:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750895AbXH2UVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 16:21:53 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:45403 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbXH2UVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 16:21:53 -0400
Date: Wed, 29 Aug 2007 21:20:48 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Alexey Dobriyan <adobriyan@sw.ru>, torvalds@osdl.org,
       len.brown@intel.com, ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc4: maxcpus still broken
In-Reply-To: <Pine.LNX.4.64.0708290546430.31816@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0708292109330.20443@blonde.wat.veritas.com>
References: <20070828111431.GA27707@localhost.sw.ru>
 <6bffcb0e0708281635v2fdca60bv40099d0583599637@mail.gmail.com>
 <20070829043921.GA1765@martell.zuzino.mipt.ru>
 <Pine.LNX.4.64.0708290546430.31816@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Aug 2007, Hugh Dickins wrote:
> On Wed, 29 Aug 2007, Alexey Dobriyan wrote:
> > On Wed, Aug 29, 2007 at 01:35:57AM +0200, Michal Piotrowski wrote:
> > > On 28/08/07, Alexey Dobriyan <adobriyan@sw.ru> wrote:
> > > > Every time I try to boot with maxcpus=1 it dies show_stat():
> > > 
> > > Is this a regression?
> > 
> > yep
> 
> A regression since when, I wonder?  Please do NOT waste any time
> bisecting, but I'd be interested to know which release or -rc you
> previously found it worked on.

And thank you, you answered:
Anything before "ACPI: boot correctly with "nosmp" or "maxcpus=0"" is
fine.

Right, though that surprised me (and had me confused for a while,
I'd forgotten that I'd backported those mods into an earlier tree).

> 
> When I gave the code a quick look, it appeared to be something
> which has long been wrong;

So I was wrong about that.

> but I didn't investigate whether per-cpu
> allocation has changed recently.  My _suspicion_, no more than that,
> is that it might be a regression to you because you're now forced
> to have CONFIG_HOTPLUG_CPU=y where you didn't need it before.

Precisely the reverse: it only happens when CONFIG_HOTPLUG_CPU is
not set.  Which accounts for why I didn't see it when testing my
maxcpus=N fix, since I had CONFIG_HOTPLUG_CPU on at that time.

> 
> Anyway, it doesn't matter too much what it's a regression since:
> it's a bug that needs fixing whatever, and should be simple.

I've underestimated it, and done little beyond confuse myself today.
It'd be easy enough to fix, but there are probably about 20 different
ways, finding the right way is not so obvious to me.  I need to get
to understand it better tomorrow (unless someone beats me to it:
I know little of the possible, the present and the online myself).

Hugh
