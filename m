Return-Path: <linux-kernel-owner+w=401wt.eu-S1761376AbYDOIbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761376AbYDOIbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 04:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754978AbYDOIbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 04:31:41 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:25900 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659AbYDOIbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 04:31:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=Kli45kM799ixh6UwMSVmnbLCvH4+EE8YTxapAlTqoiyl1TbM/pUfk+2jEegGYqo42MN9qWBS4YcHxMHHA/gRxOywjR02HAn+POaKVWBcKdAZcELTOPJPKL6gbIacBX8cIRxo7UUoZvjJ3/8ggW3Os7V5aAXOUM0MNdgSlr0SLos=
Reply-To: yhlu.kernel@gmail.com
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [bug] SLUB + mm/slab.c boot crash in -rc9
Date: Tue, 15 Apr 2008 01:31:18 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <20080411074145.GA4944@elte.hu> <84144f020804142341ic4621c9o6de06d68eee74871@mail.gmail.com> <20080415070811.GA15499@elte.hu>
In-Reply-To: <20080415070811.GA15499@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804150131.18469.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 April 2008 12:08:11 am Ingo Molnar wrote:
> 
> * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
> > On Tue, Apr 15, 2008 at 9:25 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > >  so it's probably the first few page allocations (setup_cpu_cache())
> > >  going wrong already - suggesting a some fundamental borkage in SLAB?
> > 
> > I think it's still pointing to the page allocator and/or setting up 
> > the zonelists...
> 
> i did a .config bisection and it pinpointed CONFIG_SPARSEMEM=y as the 
> culprit. Changing it to FLATMEM gives a correctly booting system.
> 
..
> why are there no good debug logs possible in this area? To debug such 
> bugs we'd need an early dump of the precise layout of all memory maps, 
> what points where, how large it is, where it is allocated - and then 
> compare it with how the rest of the system is layed out - looking at 
> possible overlaps or other bugs. This 8-way box is a pain to debug on, 
> it takes a long time to boot it up, etc. etc.

so same config 64 bit with SLUB works and only 32bit is broken? or it 2.6.24 with 32bit + sparse + slub is broken already?

YH

