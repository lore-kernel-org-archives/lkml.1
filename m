Return-Path: <linux-kernel-owner+w=401wt.eu-S1759261AbYDPCQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261AbYDPCQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 22:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbYDPCQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 22:16:49 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54132 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbYDPCQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 22:16:48 -0400
Date: Wed, 16 Apr 2008 11:20:15 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Christoph Lameter" <clameter@sgi.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       "Mel Gorman" <mel@csn.ul.ie>, "Nick Piggin" <npiggin@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, apw@shadowen.org
Subject: Re: [patch] mm: sparsemem memory_present() memory corruption fix
Message-Id: <20080416112015.79ac4867.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <86802c440804151900t3357eb52w4cf2339b38ce2c17@mail.gmail.com>
References: <20080415201734.GA25628@elte.hu>
	<alpine.LFD.1.00.0804151353380.2879@woody.linux-foundation.org>
	<20080416000356.GA24737@elte.hu>
	<20080416001816.GA26295@elte.hu>
	<86802c440804151732j519a541t9d8e4f6b49a53313@mail.gmail.com>
	<20080416004430.GA26928@elte.hu>
	<Pine.LNX.4.64.0804151745440.6876@schroedinger.engr.sgi.com>
	<20080416005231.GC26996@elte.hu>
	<20080416011704.GA439@elte.hu>
	<86802c440804151830h3917619ct5f1077530020f13f@mail.gmail.com>
	<86802c440804151900t3357eb52w4cf2339b38ce2c17@mail.gmail.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2008 19:00:18 -0700
"Yinghai Lu" <yhlu.kernel@gmail.com> wrote:

> On Tue, Apr 15, 2008 at 6:30 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >
> > On Tue, Apr 15, 2008 at 6:17 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >  >
> >  >  * Ingo Molnar <mingo@elte.hu> wrote:
> >  >
> >  >  > > > this is the only call to memory_present() we do in 32-bit arch
> >  >  > > > setup, so it's required.
> >  >  > >
> >  >  > > We could clip there if SPARSEMEM is configured. I wonder if this
> >  >  > > affects other platforms that need HIGHMEM support?
> >  >  >
> >  >  > clip where and what?
> >  >
> >  >  i.e. as per my previous argument i'd consider the need to sanitize the
> >  >  calls in the architecture fundamentally wrong.
> >  >
> >  >  whether the core code emits a warning or allows the call is an
> >  >  additional question i mention in the changelog - but the core sparse
> >  >  memory code should _definitely_ not silently overflow a key internal
> >  >  array ... (of which data structure the architecture code is not even
> >  >  aware of)
> >
> >  or you can move that check into find_max_pfn for x86_32? so it will
> >  not affect other platform regarding Christoph's concern?
> >
> the patch doesn't have side effects on x86_64.
> 
also no side effects on my ia64/NUMA box, which has sparse physical memory map.

Thanks,
-Kame



