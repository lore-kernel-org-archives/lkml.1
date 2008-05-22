Return-Path: <linux-kernel-owner+w=401wt.eu-S1765034AbYEVWvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765034AbYEVWvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755911AbYEVWvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:51:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42698 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873AbYEVWvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:51:31 -0400
Date: Fri, 23 May 2008 00:59:49 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, Glauber Costa <gcosta@redhat.com>,
       Miquel van Smoorenburg <miquels@cistron.nl>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       andi-suse@firstfloor.org
Subject: Re: 2.6.26: x86/kernel/pci_dma.c: gfp |= __GFP_NORETRY ?
Message-ID: <20080522225949.GE31727@one.firstfloor.org>
References: <20080521113028.GA24632@xs4all.net> <48341A57.1030505@redhat.com> <20080522084736.GC31727@one.firstfloor.org> <alpine.LFD.1.10.0805222157300.3295@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805222157300.3295@apollo.tec.linutronix.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 09:58:11PM +0200, Thomas Gleixner wrote:
> On Thu, 22 May 2008, Andi Kleen wrote:
> > On Wed, May 21, 2008 at 09:49:27AM -0300, Glauber Costa wrote:
> > > probably andi has a better idea on why it was added, since it used to 
> > > live in his tree?
> > 
> > d_a_c() tries a couple of zones, and running the oom killer for each
> > is inconvenient. Especially for the 16MB DMA zone which is unlikely
> > to be cleared by the OOM killer anyways because normal user applications
> > don't put pages in there. There was a real report with some problems
> > in this area.
> 
> Can you give some pointers please ?

To the bug report? Memory is fuzzy, but I think it was some SUSE bugzilla
report, might have been for SLES.

Anyways the reasoning is still valid. Longer term the mask allocator
would be the right fix, shorter term a new GFP flag as proposed 
sounds reasonable.

The trick is just that you need different __GFP_ flags for the different
allocations. e.g. the first the "higher zone" quick try should
continue to use __GFP_NORETRY. And the 16MB one should too. It would
only make sense for the main request.

In the mask allocator patchkit kernel it should be also ok already.

-Andi
