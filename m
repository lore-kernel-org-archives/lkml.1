Return-Path: <linux-kernel-owner+w=401wt.eu-S2992619AbXCBRBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992619AbXCBRBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 12:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992625AbXCBRBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 12:01:48 -0500
Received: from calculon.skynet.ie ([193.1.99.88]:33728 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992619AbXCBRBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 12:01:48 -0500
Date: Fri, 2 Mar 2007 17:01:42 +0000
To: Paul Mundt <lethal@linux-sh.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, balbir@in.ibm.com, npiggin@suse.de,
       clameter@engr.sgi.com, mingo@elte.hu, jschopp@austin.ibm.com,
       arjan@infradead.org, mbligh@mbligh.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related patches
Message-ID: <20070302170142.GC14379@skynet.ie>
References: <20070301101249.GA29351@skynet.ie> <20070301160915.6da876c5.akpm@linux-foundation.org> <Pine.LNX.4.64.0703011642190.12485@woody.linux-foundation.org> <45E7835A.8000908@in.ibm.com> <Pine.LNX.4.64.0703011939120.12485@woody.linux-foundation.org> <20070301195943.8ceb221a.akpm@linux-foundation.org> <Pine.LNX.4.64.0703012105080.3953@woody.linux-foundation.org> <20070302145029.d4847577.kamezawa.hiroyu@jp.fujitsu.com> <20070302061548.GA13552@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070302061548.GA13552@linux-sh.org>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (02/03/07 15:15), Paul Mundt didst pronounce:
> On Fri, Mar 02, 2007 at 02:50:29PM +0900, KAMEZAWA Hiroyuki wrote:
> > On Thu, 1 Mar 2007 21:11:58 -0800 (PST)
> > Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > The whole DRAM power story is a bedtime story for gullible children. Don't 
> > > fall for it. It's not realistic. The hardware support for it DOES NOT 
> > > EXIST today, and probably won't for several years. And the real fix is 
> > > elsewhere anyway (ie people will have to do a FBDIMM-2 interface, which 
> > > is against the whole point of FBDIMM in the first place, but that's what 
> > > you get when you ignore power in the first version!).
> > > 
> > 
> > Note:
> > I heard embeded people often designs their own memory-power-off control on
> > embeded Linux. (but it never seems to be posted to the list.) But I don't know
> > they are interested in generic memory hotremove or not.
> > 
> Yes, this is not that uncommon of a thing. People tend to do this in a
> couple of different ways, in some cases the system is too loaded to ever
> make doing such a thing at run-time worthwhile, and in those cases these
> sorts of things tend to be munged in with the suspend code. Unfortunately
> it tends to be quite difficult in practice to keep pages in one place,
> so people rely on lame chip-select hacks and limiting the amount of
> memory that the kernel treats as RAM instead so it never ends up being an
> issue. Having some sort of a balance would certainly be nice, though.

If the range of memory you want to offline is MAX_ORDER_NR_PAGES,
anti-fragmentation should group pages you can reclaim into those size of
chunks. It might simplify the number of hacks you have to perform to
limit where the kernel uses memory.

-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
