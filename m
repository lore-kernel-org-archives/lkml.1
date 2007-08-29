Return-Path: <linux-kernel-owner+w=401wt.eu-S1756405AbXH2FFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbXH2FFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 01:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbXH2FFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 01:05:12 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:39906 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbXH2FFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 01:05:11 -0400
Date: Wed, 29 Aug 2007 06:03:34 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Alexey Dobriyan <adobriyan@sw.ru>, torvalds@osdl.org,
       len.brown@intel.com, ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc4: maxcpus still broken
In-Reply-To: <20070829043921.GA1765@martell.zuzino.mipt.ru>
Message-ID: <Pine.LNX.4.64.0708290546430.31816@blonde.wat.veritas.com>
References: <20070828111431.GA27707@localhost.sw.ru>
 <6bffcb0e0708281635v2fdca60bv40099d0583599637@mail.gmail.com>
 <20070829043921.GA1765@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Aug 2007, Alexey Dobriyan wrote:
> On Wed, Aug 29, 2007 at 01:35:57AM +0200, Michal Piotrowski wrote:
> > On 28/08/07, Alexey Dobriyan <adobriyan@sw.ru> wrote:
> > > Every time I try to boot with maxcpus=1 it dies show_stat():
> > 
> > Is this a regression?
> 
> yep

A regression since when, I wonder?  Please do NOT waste any time
bisecting, but I'd be interested to know which release or -rc you
previously found it worked on.

When I gave the code a quick look, it appeared to be something
which has long been wrong; but I didn't investigate whether per-cpu
allocation has changed recently.  My _suspicion_, no more than that,
is that it might be a regression to you because you're now forced
to have CONFIG_HOTPLUG_CPU=y where you didn't need it before.

Anyway, it doesn't matter too much what it's a regression since:
it's a bug that needs fixing whatever, and should be simple.
My x86_64 was running other tests yesterday which I didn't want
to interrupt, but I'll take a look later on today.

> 
> > Hugh fixed some issues on x86-64 commit 813409771731d80e6fa94199adf99f2269a4afc0
> 
> This is 2.6.23-rc4, which has this fix, yes.
> 
> And I have second box with exactly same behaviour: x86_64 E6400, it also has ACPI=n
> Turning on ACPI doesn't make it any better, though.

Hugh
